// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.23;

import {Test} from "forge-std/Test.sol";

import {MockPortal} from "omni/core/test/utils/MockPortal.sol";
import {ConfLevel} from "omni/core/src/libraries/ConfLevel.sol";

import {Greeter} from "src/Greeter.sol";
import {GreetingBook} from "src/GreetingBook.sol";

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

        bytes memory xcalldata = abi.encodeCall(GreetingBook.greet, (user, greeting));

        vm.expectCall(
            address(portal),
            abi.encodeCall(
                MockPortal.xcall,
                (
                    portal.omniChainId(),
                    ConfLevel.Latest,
                    greeter.greetingBook(),
                    xcalldata,
                    greeter.XGREET_GAS_LIMIT()
                )
            )
        );
        
        uint256 fee = portal.feeFor(portal.omniChainId(), xcalldata, greeter.XGREET_GAS_LIMIT());
        greeter.greet{value: fee}(greeting);
    }

    function testGreetInsufficientFee() public {
        string memory greeting = "Hello, world!";

        bytes memory xcalldata = abi.encodeCall(Greeter.greet, (greeting));

        uint256 fee = portal.feeFor(portal.omniChainId(), xcalldata, greeter.XGREET_GAS_LIMIT());

        vm.expectRevert();
        greeter.greet{value: fee - 1}(greeting);
    }
}
