// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.23;

import {Script, console} from "forge-std/Script.sol";
import {GreetingBook} from "src/GreetingBook.sol";


contract DeployGreetingBook is Script {
    function run() external {
        address portalAddress = vm.envAddress("PORTAL_ADDRESS");

        vm.startBroadcast();
        GreetingBook greetingBook = new GreetingBook(portalAddress);
        vm.stopBroadcast();

        console.log("Deployed GreetingBook at:", address(greetingBook));
    }
}
