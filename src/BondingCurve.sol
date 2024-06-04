// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import { ERC20 } from "openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";
import { Ownable } from "openzeppelin-contracts/contracts/access/Ownable.sol";
import { ReentrancyGuard } from "openzeppelin-contracts/contracts/utils/ReentrancyGuard.sol";

/**
 * @title Token sale and buyback with bonding curve. 
 * 
 * The more tokens a user buys, the more expensive the token becomes. 
 * To keep things simple, use a linear bonding curve. 
 *
 * @notice Practice problem from RareSkill's week1 assignment
 * 
 * @author Johnny Liang
 */
contract BondingCurveTokenContract is ERC20, Ownable, ReentrancyGuard {
  uint256 public constant MAX_SUPPLY = 1000000 * 10 ** 18;
  
  constructor() 
    ERC20("BondingCurveToken", "Bond")
    Ownable(msg.sender) 
  {

  }

  fallback() exteral payable {}

  function buyTokens(uint256 amount) exteral payable {
    uint256 cost = _getAmountsToBuy(amount);
    require(msg.value >= cost, "not enough to buy");
    _mint(msg.sender, amount);
  }

  function sellTokens(uint256 amount) exteral nonReentrant {
    require(balanceOf(msg.sender) >= amount, "Insufficient token balance");
    uint256 refund = _getAmountsToSell(amount);
    require(refund < address(this).balance, "Insufficient fund to return");

    _burn(msg.sender, amount);
    (bool success, ) = msg.sender.call.value(amount)("");
    require(success, "Refund failed");
  }
  
  /**
   * @dev given a continuous token supply and amount intent to buy, calculate the sales price
   *
   * @note since the bonding curve for this exercise is linear, which can be considered as f(x) = mx, where m is 1. 
   * The intergral of this function is  f(x) = x ^ 2 / 2, which in this case poolBalance = tokenSupply ^ 2 / 2
   * Using this formular we can calculate the when Alice buy at tokenSupplyA as poolBalanceA = tokenSupplyA ^ 2 / 2, and  
   * if Bob come in and start buying tokenSupplyB, where B is 10 tokens away from A, then poolBalanceB = (tokenSupplyA + 10)^ 2 / 2
   *  
   * 
   * Formula:
   * TokenPrice = (tokenSupplyA + xAMoutnt) ^2 / 2 - tokenSupplyA ^2 / 2
   *
   * @param _intentToPurchase   amount of token intent to buy
   *
   *  @return purchase price
  */
  function _getAmountsToBuy(uint256 _intentToPurchase) private view returns (uint256) {
    require(_intentToPurchase > 0, "invalid amount to buy");
    uint256 totalSupply = totalSupply();
    return (totalSupply + _intentToPurchase) ** 2 / 2 - totalSupply ** 2 / 2;
  }

  /**
   * @dev given a continuous token supply, reserve token balance, reserve ratio, and a deposit amount (in the reserve token),
   * calculates the return for a given conversion (in the continuous token)
   *
   * Formula:
   * Return = _supply * ((1 + _depositAmount / _reserveBalance) ^ (_reserveRatio / MAX_RESERVE_RATIO) - 1)
   *
   * @param _intentToSell amount of token intent to buy
   *
   *  @return refund amount
  */
  function _getAmountsToSell(uint256 _intentToSell) private view returns (uint256) {
    require(_intentToSell > 0, "invalid amount to sell");
    uint256 totalSupply = totalSupply();
    return totalSupply ** 2 / 2 - (totalSupply - _intentToSell) ** 2 / 2;
  }
}