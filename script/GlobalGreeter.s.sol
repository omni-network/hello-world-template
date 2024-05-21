// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.23;

import {Script, console} from "forge-std/Script.sol";
import {GlobalGreeter} from "../src/GlobalGreeter.sol";

/**
 * @title DeployGlobalGreeter
 * @notice Script for deploying the GlobalGreeter contract
 */
contract DeployGlobalGreeter is Script {
    /**
     * @dev Run the deployment script
     */
    function run() external {
        // Get the address of the portal from the environment
        address portalAddress = vm.envAddress("PORTAL_ADDRESS");

        // Start broadcasting the transaction
        vm.startBroadcast();

        // Deploy the GlobalGreeter contract
        GlobalGreeter globalGreeter = new GlobalGreeter(portalAddress);
        console.log("Deployed GlobalGreeter at:", address(globalGreeter));

        // Stop broadcasting the transaction
        vm.stopBroadcast();
    }
}
