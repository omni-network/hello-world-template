// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.23;

import {Test} from "forge-std/Test.sol";
import {RollupGreeter} from "src/RollupGreeter.sol";
import {MockPortal} from "omni/contracts/test/utils/MockPortal.sol";

/**
 * @title RollupGreeterTest
 * @notice Test suite for the RollupGreeter contract
 */
contract RollupGreeterTest is Test {
    RollupGreeter rollupGreeter;
    MockPortal portal;

    /**
     * @dev Set up the test environment
     */
    function setUp() public {
        portal = new MockPortal();
        // Deploy RollupGreeter contract with MockPortal address, Omni chain ID, and greeter contract address
        rollupGreeter = new RollupGreeter(address(portal), 1, address(0xdeadbeef));
    }

    /**
     * @dev Test the greet function
     */
    function testGreet() public {
        string memory greeting = "Hello, world!";
        // Get the fee required for the greet function
        uint256 fee = portal.feeFor(rollupGreeter.omniChainId(), abi.encodeWithSignature("greet(string)", greeting));

        // Mock expected calls to the portal contract
        vm.expectCall(
            address(portal),
            abi.encodeWithSignature(
                "feeFor(uint64,bytes)", 
                rollupGreeter.omniChainId(), 
                abi.encodeWithSignature("greet(string)", greeting)
            )
        );
        vm.expectCall(
            address(portal),
            abi.encodeWithSignature(
                "xcall(uint64,address,bytes)", 
                rollupGreeter.omniChainId(), 
                rollupGreeter.omniChainGreeter(), 
                abi.encodeWithSignature("greet(string)", greeting)
            )
        );

        // Send enough ether to cover the fee
        rollupGreeter.greet{value: fee}(greeting);
    }

    /**
     * @dev Test the greet function with insufficient fee
     */
    function testGreetInsufficientFee() public {
        string memory greeting = "Hello, world!";
        // Get the fee required for the greet function
        uint256 fee = portal.feeFor(rollupGreeter.omniChainId(), abi.encodeWithSignature("greet(string)", greeting));

        // Deal ether to the contract address to simulate insufficient funds
        vm.deal(address(rollupGreeter), 1 ether);

        // Send less ether than the fee, expecting it to revert
        try rollupGreeter.greet{value: fee - 1}(greeting) {
            fail(); // If it doesn't revert, fail the test
        } catch Error(string memory reason) {
            assertEq(reason, "RollupGreeter: little fee"); // Check if the revert reason is correct
        }
    }
}
