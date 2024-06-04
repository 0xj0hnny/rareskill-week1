// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {UntrustedEscow} from "../src/UntrustedEscow.sol";
import {MockERC20} from "./MockERC20.t.sol";

import { IERC20 } from "openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";

contract UntrustedEscowTest is Test {
  UntrustedEscow public untrustedEscow;
  MockERC20 public mockERC20;
  uint256 amount = 1000000 * 10 ** 18;

  function setUp() public {
    untrustedEscow = new UntrustedEscow();
    mockERC20 = new MockERC20();
    mockERC20.approve(address(untrustedEscow), amount);
  }

  function testDeposit() public {
    address Alice = address(1);
    vm.deal(Alice, 1 ether);
    vm.prank(Alice);
    untrustedEscow.deposit(address(mockERC20), 0.5e18);

  }


}