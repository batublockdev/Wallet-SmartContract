//SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

error Wallet_NotOwner();
error Wallet_NotEnoughFunds();

contract Wallet {
    address public immutable i_owner;

    constructor() {
        i_owner = msg.sender;
    }

    function deposit() public payable {}

    modifier onlyOwner() {
        if (msg.sender != i_owner) revert Wallet_NotOwner();
        _;
    }

    modifier EnoughFunds(uint256 amount) {
        if (address(this).balance < amount) revert Wallet_NotEnoughFunds();
        _;
    }

    function withdraw(uint256 amount) public onlyOwner EnoughFunds(amount) {
        (bool callSuccess, ) = payable(i_owner).call{value: amount}("");
        require(callSuccess, "Call failedxx");
    }

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
