// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {GodModeToken} from "../src/GodModeToken.sol";

import { IERC20 } from "openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";


contract GodModeTokenTest is Test {
    GodModeToken public godModeToken;
    address godAddress = address(99);
    uint256 amount = 10_000 * 10 ** 18;

    function setUp() public {
        godModeToken = new GodModeToken(godAddress);
    }

    function test_TokenInfo() public view {
        assertEq(godModeToken.name(), "GodModeToken");
        assertEq(godModeToken.symbol(), "God");
        assertEq(godModeToken.totalSupply(), amount);
    }

    function test_TokenTransfer() public {
        address contractOwner = address(this);
        address Alice = address(1);
        uint256 mintAmount = 900 * 10 ** 18;
        uint256 godGiven = 700 * 10 ** 18;
        vm.prank(contractOwner);
        
        // admin set Alice to be banned
        godModeToken.setAddressBanned(Alice);
        
        // transfer tokens to Alice and expected tx to be reverted
        vm.expectRevert();
        godModeToken.transfer(Alice, mintAmount);
        assertEq(godModeToken.balanceOf(Alice), 0);
        
        // god mint some tokens
        vm.prank(godAddress);
        godModeToken.mint(mintAmount);
        assertEq(godModeToken.balanceOf(godAddress), mintAmount);
        
        // god transfer tokens to Alice and expected Alice has the expected mintAmount
        vm.prank(godAddress);
        godModeToken.godTransfer(Alice, godGiven);
        assertEq(godModeToken.balanceOf(Alice), godGiven);
        assertEq(godModeToken.balanceOf(godAddress), mintAmount - godGiven);
    }
}
