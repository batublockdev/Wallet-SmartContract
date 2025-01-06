// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Wallet} from "../src/Wallet.sol";
import {Script, console} from "forge-std/Script.sol";
import {DevOpsTools} from "lib/foundry-devops/src/DevOpsTools.sol";

contract DepositWallet is Script {
    uint256 constant DEPOSIT_AMOUNT = 0.1 ether;

    function depositwallet(address mostRecentDeployment) public {
        vm.startBroadcast();
        Wallet(payable(mostRecentDeployment)).deposit{value: DEPOSIT_AMOUNT}();
        vm.stopBroadcast();
    }

    function run() external {
        address contractAddress = DevOpsTools.get_most_recent_deployment(
            "Wallet",
            block.chainid
        );
        depositwallet(contractAddress);
    }
}

contract WithdrawWallet is Script {
    uint256 constant DEPOSIT_AMOUNT = 0.05 ether;

    function withdrawwallet(address mostRecentDeployment) public {
        vm.startBroadcast();
        Wallet(payable(mostRecentDeployment)).withdraw(DEPOSIT_AMOUNT);
        vm.stopBroadcast();
    }

    function run() external {
        address contractAddress = DevOpsTools.get_most_recent_deployment(
            "Wallet",
            block.chainid
        );
        withdrawwallet(contractAddress);
    }
}

contract TransferWallet is Script {
    uint256 constant DEPOSIT_AMOUNT = 0.05 ether;
    address s_ADDRESS = address(new Wallet());

    function transferwallet(address mostRecentDeployment) public {
        vm.startBroadcast();
        Wallet(payable(mostRecentDeployment)).transfer(
            s_ADDRESS,
            DEPOSIT_AMOUNT
        );
        vm.stopBroadcast();
    }

    function run() external {
        address contractAddress = DevOpsTools.get_most_recent_deployment(
            "Wallet",
            block.chainid
        );
        transferwallet(contractAddress);
    }
}
