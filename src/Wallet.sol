//SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

error Wallet_NotOwner();
error Wallet_NotEnoughFunds();

/**
 * @title Wallet
 * @author batublockdev
 * @notice This contract is a simple wallet that allows the owner to deposit, withdraw, and transfer funds.
 */

contract Wallet {
    address public immutable i_owner;

    constructor() {
        i_owner = msg.sender;
    }

    //funtion to deposit funds
    function deposit() public payable {}

    modifier onlyOwner() {
        if (msg.sender != i_owner) revert Wallet_NotOwner();
        _;
    }

    modifier EnoughFunds(uint256 amount) {
        if (address(this).balance < amount) revert Wallet_NotEnoughFunds();
        _;
    }

    //funtion to withdraw funds
    function withdraw(uint256 amount) public onlyOwner EnoughFunds(amount) {
        (bool callSuccess, ) = payable(i_owner).call{value: amount}("");
        require(callSuccess, "Call failedxx");
    }

    //funtion to transfer funds
    function transfer(
        address to,
        uint256 amount
    ) public onlyOwner EnoughFunds(amount) {
        require(to != address(0), "Invalid address");
        (bool callSuccess, ) = payable(to).call{value: amount}("");
        require(callSuccess, "Call failed");
    }

    function getBalance() public view onlyOwner returns (uint256) {
        return address(this).balance;
    }

    fallback() external payable {
        deposit();
    }

    receive() external payable {
        deposit();
    }
}
