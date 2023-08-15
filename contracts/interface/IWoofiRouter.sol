// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.0;

interface IWoofiRouter {
    function swap(
        address fromToken,
        address toToken,
        uint256 fromAmount,
        uint256 minToAmount,
        address payable to,
        address rebateTo
    ) external payable returns (uint256 realToAmount);

    function querySwap(address fromToken, address toToken, uint256 fromAmount)
        external
        view
        returns (uint256 toAmount);
}
