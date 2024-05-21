// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.23;

/// @dev A struct for storing greeting related data
struct Greeting {
    uint64 sourceChainId;   // The source chain ID of the greeting
    uint256 timestamp;      // The timestamp of the greeting
    uint256 fee;            // The portal fee for the greeting
    address sender;         // The sender of the greeting
    address xsender;        // The cross-chain sender of the greeting
    string message;         // The message of the greeting
}
