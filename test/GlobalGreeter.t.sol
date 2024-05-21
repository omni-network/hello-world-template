// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.23;

import {MockPortal} from "omni/contracts/test/utils/MockPortal.sol";
import {Test} from "forge-std/Test.sol";
import {GlobalGreeter} from "src/GlobalGreeter.sol";
import {Greeting} from "src/Greeting.sol";

/**
 * @title GlobalGreeterTest
 * @notice Test suite for the GlobalGreeter contract
 * @dev This contract contains test cases to verify the functionality of the GlobalGreeter contract.
 */
contract GlobalGreeterTest is Test {
    GlobalGreeter greeter;
    MockPortal portal;

    /**
     * @dev Sets up the test environment with a new GlobalGreeter contract and a MockPortal instance
     */
    function setUp() public {
        portal = new MockPortal();
        greeter = new GlobalGreeter(address(portal));
    }

    /**
     * @dev Tests the greet function of the GlobalGreeter contract
     * @notice This test verifies that the greet function correctly updates the lastGreet state variable.
     */
    function testGreet() public {
        string memory greeting = "Hello, world!";
        greeter.greet(greeting);
        Greeting memory lastGreet;
        (lastGreet.sourceChainId, lastGreet.timestamp, lastGreet.fee, lastGreet.sender, lastGreet.xsender, lastGreet.message) = greeter.lastGreet();
        assertEq(lastGreet.message, greeting);
    }

    /**
     * @dev Tests the cross-chain greet functionality of the GlobalGreeter contract
     * @notice This test verifies that the GlobalGreeter contract correctly handles cross-chain greet requests via the MockPortal.
     */
    function testXGreet() public {
        string memory greeting = "Hello, world!";
        portal.mockXCall(
            0, address(greeter), abi.encodeWithSelector(GlobalGreeter.greet.selector, greeting)
        );
        Greeting memory lastGreet;
        (lastGreet.sourceChainId, lastGreet.timestamp, lastGreet.fee, lastGreet.sender, lastGreet.xsender, lastGreet.message) = greeter.lastGreet();
        assertEq(lastGreet.message, greeting);
    }
}
