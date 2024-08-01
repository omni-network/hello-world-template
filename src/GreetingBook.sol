// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.23;

import {XApp} from "omni/core/src/pkg/XApp.sol";
import {ConfLevel} from "omni/core/src/libraries/ConfLevel.sol";

/**
 * @title GreetingBook
 * @dev This contract is deployed to the Omni EVM, and records greetings from all supported chains. It only stores the latest.
 */
contract GreetingBook is XApp {
    struct Greeting {
        address user;
        string message;
        uint64 sourceChainId;
        uint256 timestamp;
    }

    Greeting public lastGreet;

    constructor(address portal) XApp(portal, ConfLevel.Latest) {}

    function greet(address user, string calldata _greeting) external xrecv {
        require(isXCall(), "GreetingBook: only xcalls");

        lastGreet = Greeting(user, _greeting, xmsg.sourceChainId, block.timestamp);
    }
}
