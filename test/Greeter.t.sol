// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.23;

import {Test} from "forge-std/Test.sol";

import {MockPortal} from "omni//core/test/utils/MockPortal.sol";
import {ConfLevel} from "omni/core/src/libraries/ConfLevel.sol";

import {Greeter} from "src/Greeter.sol";

contract GreeterTest is Test {
    address user;
    Greeter greeter;
    MockPortal portal;

    function setUp() public {
        user = address(this);
        portal = new MockPortal();
        greeter = new Greeter(address(portal), address(0xdeadbeef));
    }

    function testGreet() public {
        string memory greeting = "Hello, world!";

        uint256 fee = portal.feeFor(
            portal.omniChainId(), abi.encodeWithSignature("greet(string)", greeting), greeter.DEST_TX_GAS_LIMIT()
        );

        vm.expectCall(
            address(portal),
            abi.encodeWithSignature(
                "feeFor(uint64,bytes,uint64)",
                portal.omniChainId(),
                abi.encodeWithSignature("greet(address,string)", user, greeting),
                greeter.DEST_TX_GAS_LIMIT()
            )
        );
        vm.expectCall(
            address(portal),
            abi.encodeWithSignature(
                "xcall(uint64,uint8,address,bytes,uint64)",
                portal.omniChainId(),
                ConfLevel.Latest,
                greeter.greetingBook(),
                abi.encodeWithSignature("greet(address,string)", user, greeting),
                greeter.DEST_TX_GAS_LIMIT()
            )
        );

        greeter.greet{value: fee}(greeting);
    }

    function testGreetInsufficientFee() public {
        string memory greeting = "Hello, world!";

        uint256 fee = portal.feeFor(
            portal.omniChainId(), abi.encodeWithSignature("greet(string)", greeting), greeter.DEST_TX_GAS_LIMIT()
        );

        vm.expectRevert();
        greeter.greet{value: fee - 1}(greeting);
    }
}
