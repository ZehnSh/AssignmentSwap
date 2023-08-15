// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.18;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "./interface/IKyberRouter.sol";
import "./interface/IZyberRouter.sol";
import "./interface/IWoofiRouter.sol";
import "./interface/ITraderJoeV2_1.sol";
import "hardhat/console.sol";

contract swapper {
    IKyberRouter public immutable IKRouter;
    IZyberRouter public immutable IZRouter;
    IWoofiRouter public immutable IWRouter;
    ITraderJoeV2_1 public immutable ITJRouter;
    address public constant weth = 0x82aF49447D8a07e3bd95BD0d56f35241523fBab1;
    address public constant usdc = 0xFF970A61A04b1cA14834A43f5dE4533eBDDB5CC8;
    address public immutable usdt = 0xFd086bC7CD5C481DCC9C85ebE478A1C0b69FCbb9;
    address public TJV2_1PairAddress;

    address public constant eth = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;
    address public constant ITJPair = 0xd387c40a72703B38A5181573724bcaF2Ce6038a5;
    uint256 public constant pairBinSteps = 15;
    uint256 internal _addValueDeadline = 60 seconds;

    uint256 firstSwapPercentage = 60;
    uint256 secondSwapPercentage = 40;

    constructor(address _kyberRouter, address _IZRouter, address _IWRouter, address _TJRouter) {
        IKRouter = IKyberRouter(_kyberRouter);
        IZRouter = IZyberRouter(_IZRouter);
        IWRouter = IWoofiRouter(_IWRouter);
        ITJRouter = ITraderJoeV2_1(_TJRouter);
    }

    function Swap() external payable returns (uint256) {
        require(msg.value > 1 ether, "Insufficient amount");
        uint256 _amountIn = msg.value;
        // first 60% swap
        uint256 firstSwapAmount = calculate(_amountIn, firstSwapPercentage);

        uint256 returnKSwap = _swapKyberSwap(firstSwapAmount);
        uint256 returnZSwap = _swapZyberSwap(returnKSwap);

        // second 40% swap
        uint256 calculateAmountForSecondSwap = _amountIn - firstSwapAmount;

        uint256 secondSwapAmount = calculate(calculateAmountForSecondSwap, secondSwapPercentage);
        uint256 returnWSwap = _swapWoofiV2(secondSwapAmount);
        uint256 retunrTJSwap = _swapTraderJoeV2_1(secondSwapAmount);

        return (returnKSwap + returnZSwap + returnWSwap + retunrTJSwap);

        //swap with zyberSwap
    }

    function _swapKyberSwap(uint256 swapAmount) public payable returns (uint256) {
        console.log("started");

        uint256 _deadline = block.timestamp + _addValueDeadline;
        IKyberRouter.ExactInputSingleParams memory newExactInputSingleParams =
            IKyberRouter.ExactInputSingleParams(weth, usdt, 300, address(this), _deadline, swapAmount, 100, 0);
        console.log("started");

        (uint256 amountOut) = IKRouter.swapExactInputSingle(newExactInputSingleParams);
        return amountOut;
    }

    function _swapZyberSwap(uint256 swapAmount) public payable returns (uint256) {
        uint256 deadline = block.timestamp + _addValueDeadline;
        IERC20(usdc).approve(address(IZRouter), swapAmount);
        address[] memory path = new address[](2);
        path[0] = usdc;
        path[1] = usdt;
        uint256[] memory returnAmount = IZRouter.swapExactTokensForTokens(swapAmount, 0, path, msg.sender, deadline);
        return returnAmount[1];
    }

    function _swapWoofiV2(uint256 swapAmount) public payable returns (uint256) {
        uint256 minAmount = IWRouter.querySwap(weth, usdt, swapAmount);
        uint256 retAmount =
            IWRouter.swap{value: swapAmount}(eth, usdt, swapAmount, minAmount, payable(msg.sender), address(0));
        console.log(retAmount);
        return retAmount;
    }

    function _swapTraderJoeV2_1(uint256 swapAmount) public payable returns (uint256) {
        (, uint256 amountOut,) = ITJRouter.getSwapOut(ITJPair, uint128(swapAmount), true);
        uint256[] memory _pairBinSteps = new uint[](2);
        _pairBinSteps[0] = pairBinSteps;

        ITraderJoeV2_1.Version[] memory _version = new ITraderJoeV2_1.Version[](2);
        _version[0] = ITraderJoeV2_1.Version.V2_1;

        IERC20[] memory _path = new IERC20[](2);
        _path[0] = IERC20(weth);
        _path[1] = IERC20(usdt);

        ITraderJoeV2_1.Path memory newPath = ITraderJoeV2_1.Path(_pairBinSteps, _version, _path);

        uint256 _deadline = block.timestamp + _addValueDeadline;

        uint256 retAmountOut = ITJRouter.swapExactNATIVEForTokens(amountOut, newPath, msg.sender, _deadline);

        return retAmountOut;
    }

    function updateSwapPercentage(uint256 firstPercentage, uint256 secondPercentage) external {
        require(firstPercentage + secondPercentage == 100, "should be under range");
        firstSwapPercentage = firstPercentage;
        secondSwapPercentage = secondPercentage;
    }

    function calculate(uint256 _amount, uint256 _percentage) internal pure returns (uint256 result) {
        result = (_amount * _percentage) / 100;
    }
}
