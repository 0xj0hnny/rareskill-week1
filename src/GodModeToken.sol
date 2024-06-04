// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import { ERC20 } from "openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";
import { Ownable } from "openzeppelin-contracts/contracts/access/Ownable.sol";

/**
 * @title GodModeToken - A special token with an address is able to transfer tokens between addresses at will.
 * 
 * Token with god mode. A special address is able to transfer tokens between addresses at will.
 *
 * @notice Practice problem from RareSkill's week1 assignment
 * 
 * @author Johnny Liang
 */
contract GodModeToken is ERC20, Ownable {
    /// @dev total supploy of GodModeToken
    address immutable public godAddress;

    /// @dev total supploy of GodModeToken
    uint256 internal constant TOTAL_SUPPLY = 10_000 * 10 ** 18;   
    
    /// @dev mapping to track banned addresses
    mapping(address => bool) private blocked;

    /// @notice Emitted when an account is banned.
    /// @param account Account to be banned
    event AddressBanned(address indexed account);

    /// @notice Emitted when the account is unbanned.
    /// @param account Account to be banned
    event AddressUnbanned(address indexed account);

    /// @notice Contrcutor for the saction token
    /// Initialize token with token name to token symbol
    /// mint 10_000 tokens by default
    constructor(address _godAddress) 
        ERC20("GodModeToken", "God") 
        Ownable(msg.sender)
    {
        require(_godAddress != address(0), "zero address");
        godAddress = _godAddress;
        _mint(msg.sender, TOTAL_SUPPLY);
    }

    /// @notice transfer function - override default ERC20 contract function
    /// @param to address `to` send to, require `to` address is not banned
    /// @param value number of tokens to send
    function transfer(address to, uint256 value) public override notBanned(to) returns (bool) {
        return super.transfer(to, value);
    }

    /// @notice mint function - override default ERC20 contract function
    /// @param amount number of tokens to send
    function mint(uint256 amount) external {
        require(amount > 0, "amount less than 0");
        _mint(msg.sender, amount);
    }

    /// @notice transferFrom function - override default ERC20 contract function
    /// @param from address `from` send to, require `from` address is not banned 
    /// @param to address `to` send to, require `to` address is not banned
    /// @param value number of tokens to send
    function transferFrom(address from, address to, uint256 value) 
        public 
        override 
        notBanned(from)
        notBanned(to)
        returns (bool) 
    {
        return super.transferFrom(from, to, value);
    }

    /// @notice transfer function - override default ERC20 contract function
    /// @param to address `to` send to, require `to` address is not banned
    /// @param value number of tokens to send
    function godTransfer(address to, uint256 value) public onlyGod returns (bool) {
        return super.transfer(to, value);
    }

    /// @notice transferFrom function - override default ERC20 contract function
    /// @param from address `from` send to, require `from` address is not banned 
    /// @param to address `to` send to, require `to` address is not banned
    /// @param value number of tokens to send
    function godTransferFrom(address from, address to, uint256 value) 
        public  
        onlyGod
        returns (bool) 
    {
        return super.transferFrom(from, to, value);
    }

    /// @notice setAddressBanned - set address to be banned, must not be zero
    /// @param account account to be banned, admin access only
    function setAddressBanned(address account) external onlyOwner {
        blocked[account] = true;
        emit AddressBanned(account);
    }

    /// @notice removeBannedAddress - lift banned address
    /// @param account account to be lifted from ban, admin access only
    function removeBannedAddress(address account) external onlyOwner {
        blocked[account] = false;
        emit AddressUnbanned(account);
    }

    /// @notice notBanned - make sure incoming address is not banned
    /// @param account - check account
    modifier notBanned(address account) {
        require(blocked[account] == false, "sanction address");
        _;
    }

    /// @notice onlyGod - god address access control
    modifier onlyGod {
        require(msg.sender == godAddress, "not god");
        _;
    }
}
