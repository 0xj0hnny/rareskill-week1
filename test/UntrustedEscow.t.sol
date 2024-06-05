// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {UntrustedEscow} from "../src/UntrustedEscow.sol";
import {MockERC20} from "./mock/MockERC20.t.sol";

import { IERC20 } from "openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";

contract UntrustedEscowTest is Test {
  UntrustedEscow public untrustedEscow;
  MockERC20 public mockERC20;
  uint256 amount = 1000000 * 10 ** 18;
  uint256 depositAmount = amount / 10;
  address Alice = address(1);

  function setUp() public {
    untrustedEscow = new UntrustedEscow();
    mockERC20 = new MockERC20();
    mockERC20.approve(address(untrustedEscow), amount);
  }

  function testDepositAndWithdrawSuccess() public {
    vm.startPrank(Alice);

    // Alice mint depositAmount
    mockERC20.mint(Alice, depositAmount);
    assertEq(mockERC20.balanceOf(Alice), depositAmount);
    
    // Alice approve depositAmount
    mockERC20.approve(address(untrustedEscow), depositAmount);

    // Alice deposit to escow contact
    untrustedEscow.deposit(address(mockERC20), depositAmount);

    // check Alice balance, make sure it's 0
    assertEq(mockERC20.balanceOf(Alice), 0);

    // check usersDeposit info
    assertEq(untrustedEscow.getCurrentDepositInfo(Alice).amount, depositAmount);
    assertEq(untrustedEscow.getCurrentDepositInfo(Alice).allowWithdrawTime, block.timestamp + 3 days);
    
    // Alice try to withdraw but transaction got reverted
    vm.expectRevert();
    untrustedEscow.withdraw(depositAmount);

    // Alice able to withdraw after 3 days
    skip(block.timestamp + 3 days);
    untrustedEscow.withdraw(depositAmount);
    assertEq(mockERC20.balanceOf(Alice), depositAmount);
  }

}