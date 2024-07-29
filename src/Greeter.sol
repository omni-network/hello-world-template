// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.23;

import {XApp} from "omni/core/src/pkg/XApp.sol";
import {ConfLevel} from "omni/core/src/libraries/ConfLevel.sol";

import {GreetingBook} from "./GreetingBook.sol";

/**
 * @title Greeter
 * @dev This contract is deployed to rollups. It transmits greetings to the GreetingBook on the Omni EVM.
 */
contract Greeter is XApp {
    uint64 public constant XGREET_GAS_LIMIT = 120_000;

    address public greetingBook;

    constructor(address portal, address _greetingBook) XApp(portal, ConfLevel.Latest) {
        greetingBook = _greetingBook;
    }

    function greet(string calldata greeting) external payable {
        bytes memory data = abi.encodeCall(GreetingBook.greet, (msg.sender, greeting));

        uint256 fee = xcall(omni.omniChainId(), greetingBook, data, XGREET_GAS_LIMIT);

        // Ensure that the caller provides sufficient value to cover the fee (without this line
        //  the team must fund this contract to pay for the fees)
        require(msg.value >= fee, "Greeter: little fee");
    }
}
