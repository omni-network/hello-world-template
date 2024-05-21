// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.23;

import {XApp} from "omni/contracts/src/pkg/XApp.sol";

import {GlobalGreeter} from "./GlobalGreeter.sol";

/**
 * @title RollupGreeter
 * @notice A contract for transmitting greetings to the global chain
 * @dev This contract allows users to transmit greetings to a greeter contract deployed on the global chain via cross-chain communication.
 */
contract RollupGreeter is XApp {
    /**
     * @notice Chain ID of the Omni network
     * @dev State variable to store the Omni Network's specific chain ID
     */
    uint64 public omniChainId;

    /**
     * @notice Address of the greeter contract deployed on the global chain
     * @dev State variable to store the address of the greeter contract on the global chain
     */
    address public omniChainGreeter;

    /**
     * @dev Initializes a new RollupGreeter contract with necessary addresses and identifiers
     * @param portal             Address of the portal or relay used for cross-chain communication
     * @param _omniChainId       Chain ID for the Omni Network, specific chain for state coordination
     * @param _omniChainGreeter  Address of the greeter contract deployed on the global chain
     */
    constructor(address portal, uint64 _omniChainId, address _omniChainGreeter) XApp(portal) {
        omniChainId = _omniChainId;
        omniChainGreeter = _omniChainGreeter;
    }

    /**
     * @notice Transmits a greeting to the global chain greeter
     * @param greeting The greeting message to be transmitted
     * @dev This function initiates a cross-chain call to transmit the greeting message to the global chain greeter.
     *      Requires a value to cover cross-chain call fees.
     */
    function greet(string calldata greeting) external payable {
        bytes memory data = abi.encodeWithSelector(GlobalGreeter.greet.selector, greeting);

        // Calculate the cross-chain call fee
        uint256 fee = xcall(omniChainId, omniChainGreeter, data);

        // Ensure that the caller provides sufficient value to cover the fee
        require(msg.value >= fee, "RollupGreeter: little fee");
    }
}
