// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "@openzeppelin/contracts/interfaces/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

contract Bank {
    // mapping address=>uint
    mapping(address => uint) public deposited;

    address public immutable token;

    constructor(address _token) {
        token = _token;
    }

    // query my balance 查询余额
    function myBalance() public view returns(uint balance) {
        balance = deposited[msg.sender]/(10 ** 18);
    }

    // deposit 存款
    function deposit(uint amount) public {
        amount = amount * 10 ** 18;
        require(IERC20(token).transferFrom(msg.sender, address(this), amount), "transfer error");
        deposited[msg.sender] += amount;
    }

    // withdraw 取款
    function withdraw(uint amount) external {
        amount = amount * 10 ** 18;
        require(amount <= deposited[msg.sender], "th amount more than back of balance");
        // require(IERC20(token).transfer(msg.sender, amount), "transfer error");
        SafeERC20.safeTransfer(IERC20(token), msg.sender, amount);
        deposited[msg.sender] -= amount;
    }

    // transfer  转账
    function transfer(address to, uint amount) public {
        amount = amount * 10 ** 18;
        require(amount <= deposited[msg.sender], "th amount more than back of balance");

        deposited[msg.sender] -= amount;
        deposited[to] += amount;
    }
 }