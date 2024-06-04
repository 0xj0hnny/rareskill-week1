// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {SanctionToken} from "../src/SanctionToken.sol";

import { IERC20 } from "openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";


contract SanctionTokenTest is Test {
    SanctionToken public sanctionToken;

    function setUp() public {
        sanctionToken = new SanctionToken();
    }

    function test_TokenInfo() public view {
        assertEq(sanctionToken.name(), "SanctionToken");
        assertEq(sanctionToken.symbol(), "ST");
        assertEq(sanctionToken.totalSupply(), 10_000 * 10 ** 18);
    }

    function testTokenTransfer() public {
        address contractOwner = address(this);
        address Alice = address(1);
        uint256 amount = 900 * 10 ** 18;

        vm.prank(contractOwner);
        
        // admin set Alice to be banned
        sanctionToken.setAddressBanned(Alice);
        
        // transfer tokens to Alice and expected tx to be reverted
        vm.expectRevert();
        sanctionToken.transfer(Alice, amount);

        // admin unbanned Alice address
        sanctionToken.removeBannedAddress(Alice);

        // transfer tokens to Alice and expected Alice has the expected amount
        sanctionToken.transfer(Alice, amount);
        assertEq(sanctionToken.balanceOf(Alice), amount);
    }
}
