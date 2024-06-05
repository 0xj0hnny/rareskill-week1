// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {BondingCurveToken} from "../src/BondingCurveToken.sol";

import { IERC20 } from "openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";

contract BoningCurveTokenTest is Test {
  BondingCurveToken public bondingCurveToken;
  address Alice = address(1);
  uint256 alicePurchaseAmount = 0.5 * 10 ** 6;

  function setUp() public {
    bondingCurveToken = new BondingCurveToken();
  }
  
  function test_buyAndSellToken() public {
    vm.deal(Alice, 2 ether);
    vm.startPrank(Alice);
    bondingCurveToken.buyTokens{ value: 0.5 ether }(alicePurchaseAmount);
    assertEq(bondingCurveToken.balanceOf(Alice), alicePurchaseAmount);
    assertEq(Alice.balance, 1.5 ether);

    // Alice sell token
    bondingCurveToken.sellTokens(alicePurchaseAmount);
    assertEq(bondingCurveToken.balanceOf(Alice), 0);
    assertGt(Alice.balance, 1.5 ether);
  }
}