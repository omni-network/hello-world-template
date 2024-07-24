// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.23;

import {Test} from "forge-std/Test.sol";
import {RollupGreeter} from "src/RollupGreeter.sol";
import {MockPortal} from "omni/core/test/utils/MockPortal.sol";
import {ConfLevel} from "omni/core/src/libraries/ConfLevel.sol";

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
        rollupGreeter = new RollupGreeter(address(portal), address(0xdeadbeef));
    }

    /**
     * @dev Test the greet function
     */
    function testGreet() public {
        string memory greeting = "Hello, world!";
        // Get the fee required for the greet function
        uint256 fee = portal.feeFor(
            portal.omniChainId(), abi.encodeWithSignature("greet(string)", greeting), rollupGreeter.DEST_TX_GAS_LIMIT()
        );

        // Mock expected calls to the portal contract
        vm.expectCall(
            address(portal),
            abi.encodeWithSignature(
                "feeFor(uint64,bytes,uint64)",
                portal.omniChainId(),
                abi.encodeWithSignature("greet(string)", greeting),
                rollupGreeter.DEST_TX_GAS_LIMIT()
            )
        );
        vm.expectCall(
            address(portal),
            abi.encodeWithSignature(
                "xcall(uint64,uint8,address,bytes,uint64)",
                portal.omniChainId(),
                ConfLevel.Latest,
                rollupGreeter.omniChainGreeter(),
                abi.encodeWithSignature("greet(string)", greeting),
                rollupGreeter.DEST_TX_GAS_LIMIT()
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
        uint256 fee = portal.feeFor(
            portal.omniChainId(), abi.encodeWithSignature("greet(string)", greeting), rollupGreeter.DEST_TX_GAS_LIMIT()
        );

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
