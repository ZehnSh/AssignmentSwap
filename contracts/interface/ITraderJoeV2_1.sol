// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

interface ITraderJoeV2_1 {
    enum Version {
        V1,
        V2,
        V2_1
    }

    struct Path {
        uint256[] pairBinSteps;
        Version[] versions;
        IERC20[] tokenPath;
    }

    function swapExactNATIVEForTokens(uint256 amountOutMin, Path calldata path, address to, uint256 deadline)
        external
        payable
        returns (uint256 amountOut);

    function getSwapOut(address pair, uint128 amountIn, bool swapForY)
        external
        view
        returns (uint128 amountInLeft, uint128 amountOut, uint128 fee);
}
