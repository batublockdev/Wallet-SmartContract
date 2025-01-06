// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {Wallet} from "../../src/Wallet.sol";
import {Script} from "forge-std/Script.sol";
import {DeployWallet} from "../../script/DeployWallet.s.sol";
import {DepositWallet, WithdrawWallet, TransferWallet} from "../../script/Interactions.s.sol";

contract InteractionsTest is Test {
    Wallet wallet;
    address xuserx = makeAddr("xuserx");
    uint256 constant DEPOSIT_AMOUNT = 0.1 ether;

    function setUp() public {
        DeployWallet deploy = new DeployWallet();
        wallet = deploy.run();
        vm.deal(xuserx, DEPOSIT_AMOUNT);
    }

    function test_UserDeposit() public {
        DepositWallet deposit = new DepositWallet();
        deposit.depositwallet(address(wallet));
        assertEq(address(wallet).balance, DEPOSIT_AMOUNT);

        WithdrawWallet withdraw = new WithdrawWallet();
        withdraw.withdrawwallet(address(wallet));
        assertEq(address(wallet).balance, 0.05 ether);

        TransferWallet transfer = new TransferWallet();
        transfer.transferwallet(address(wallet));
        assertEq(address(wallet).balance, 0);
    }
}
