// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.23;

import {Script, console} from "forge-std/Script.sol";
import {Greeter} from "src/Greeter.sol";

contract DeployGreeter is Script {
    function run() external {
        address portalAddress = vm.envAddress("PORTAL_ADDRESS");
        address greetingBookAddress = vm.envAddress("DEPLOYED_ADDRESS");

        vm.startBroadcast();
        Greeter greeter = new Greeter(portalAddress, greetingBookAddress);
        vm.stopBroadcast();

        console.log("Deployed Greeter at:", address(greeter));
    }
}
