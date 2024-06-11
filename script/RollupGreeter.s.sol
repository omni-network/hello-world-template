// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.23;

import {Script, console} from "forge-std/Script.sol";
import {RollupGreeter} from "../src/RollupGreeter.sol";

/**
 * @title DeployRollupGreeter
 * @notice Script for deploying the RollupGreeter contract
 */
contract DeployRollupGreeter is Script {
    /**
     * @dev Run the deployment script
     */
    function run() external {
        // Get the address of the portal from the environment
        address portalAddress = vm.envAddress("PORTAL_ADDRESS");
        // Get the address of the global greeter from the environment
        address globalGreeterAddress = vm.envAddress("GLOBAL_GREETER_ADDRESS");

        // Start broadcasting the transaction
        vm.startBroadcast();

        // Deploy the RollupGreeter contract
        RollupGreeter rollupGreeter = new RollupGreeter(portalAddress, globalGreeterAddress);
        console.log("Deployed RollupGreeter at:", address(rollupGreeter));

        // Stop broadcasting the transaction
        vm.stopBroadcast();
    }
}
