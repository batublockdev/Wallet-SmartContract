# Solidity Wallet Contract

This is a smart contract that implements a wallet on the Ethereum blockchain where users can deposit funds, but only the owner can withdraw or transfer funds. The contract is written in Solidity and tested using **Foundry**.

## Features

- **Deposit**: Users can deposit Ether into the contract.
- **Withdraw**: Only the owner can withdraw Ether from the contract.
- **Transfer**: Only the owner can transfer Ether from the contract to another address.
- **Owner Restrictions**: The contract enforces that only the owner can perform withdrawal and transfer operations.

## Prerequisites

Before getting started, ensure that you have the following installed:

- **Foundry**: A fast, portable, and modular toolkit for Ethereum development.
  - Install Foundry using the following commands:
    ```bash
    curl -L https://foundry.paradigm.xyz | bash
    foundryup
    ```

- **Solidity**: The version of Solidity you're working with should be compatible with your contract.

## Project Setup

1. Clone the repository to your local machine:

    ```bash
    git clone https://github.com/batublockdev/Wallet-SmartContract.git
    cd Wallet-SmartContract-Solidity
    ```

2. Install Foundry dependencies (if applicable):

    ```bash
    forge install
    ```

3. **Configure Foundry**: Ensure the correct Solidity version and settings are used in `foundry.toml`.

## Contract Code

The main contract code is located in `src/Wallet.sol`. Here is a brief overview of the contract:

### `Wallet.sol`

```solidity
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
```


## Contributing

Pull requests are welcome. For major changes, please open an issue first
to discuss what you would like to change.

Please make sure to update tests as appropriate.

## License

[MIT](https://choosealicense.com/licenses/mit/)