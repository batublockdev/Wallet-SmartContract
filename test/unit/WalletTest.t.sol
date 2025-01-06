// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {Wallet} from "../../src/Wallet.sol";
import {Script} from "forge-std/Script.sol";
import {DeployWallet} from "../../script/DeployWallet.s.sol";

contract WalletTest is Test {
    Wallet wallet;
    address xuserx = makeAddr("xuserx");

    function setUp() public {
        DeployWallet deploy = new DeployWallet();
        wallet = deploy.run();
        vm.deal(xuserx, 0.1 ether);
    }

    modifier execution() {
        vm.startPrank(wallet.i_owner());
        wallet.deposit{value: 100}();
        _;
        vm.stopPrank();
    }

    function test_Deposit() public execution {
        assertEq(wallet.getBalance(), 100);
    }

    function test_Withdraw() public execution {
        wallet.withdraw(50);
        assertEq(wallet.getBalance(), 50);
    }

    function test_Transfer() public execution {
        Wallet other = new Wallet();
        wallet.transfer(address(other), 50);
        assertEq(wallet.getBalance(), 50);
        assertEq(other.getBalance(), 50);
    }

    function test_Owner() public {
        vm.prank(xuserx);
        vm.expectRevert();
        wallet.withdraw(100);
    }

    function test_notEnoughFunds() public execution {
        vm.expectRevert();
        wallet.withdraw(200);
    }

    receive() external payable {}

    fallback() external payable {}
}
