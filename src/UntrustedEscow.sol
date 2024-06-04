// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import { IERC20 } from "openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";
import { SafeERC20 } from "openzeppelin-contracts/contracts/token/ERC20/utils/SafeERC20.sol";
import { Ownable } from "openzeppelin-contracts/contracts/access/Ownable.sol";

contract UntrustedEscow is Ownable {
  using SafeERC20 for IERC20;

  struct Deposit {
    address token;
    uint256 amount;
    uint256 allowWithdrawTime;
  }

  mapping (address => Deposit) private usersDeposit;

  uint256 public constant WITHDRAW_TIME = 3 days;

  event Deposited (address indexed account, address indexed token, uint256 amount);
  event Withdrawn (address indexed account, address indexed token, uint256 amount);

  constructor() Ownable(msg.sender) {}

  function deposit(address token, uint256 amount) external {
    IERC20(token).safeTransferFrom(msg.sender, address(this), amount);

    usersDeposit[msg.sender] = Deposit({
      token: token,
      amount: amount,
      allowWithdrawTime: block.timestamp + WITHDRAW_TIME
    });
    emit Deposited(msg.sender, token, amount);
  }

  function withdraw(uint256 amount) external {
    require(usersDeposit[msg.sender].amount > 0, "Insufficient amount withdraw");
    require(usersDeposit[msg.sender].allowWithdrawTime < block.timestamp, "withdraw not allow yet");
    Deposit memory existingDeposit = usersDeposit[msg.sender];
    IERC20(existingDeposit.token).safeTransfer(msg.sender, existingDeposit.amount);
    delete usersDeposit[msg.sender];
    emit Withdrawn(msg.sender, existingDeposit.token, amount);
  }

  function getCurrentDepositInfo(address account) external view returns (Deposit memory) {
    require(account != address(0), "zero address");
    Deposit memory existingDeposit = usersDeposit[msg.sender];
    return existingDeposit;
  }

}