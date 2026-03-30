// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";
import "../src/Disperse.sol";

contract DeployDisperse is Script {
    function run() external {
        vm.startBroadcast();
        Disperse disperse = new Disperse();
        console.log("Disperse deployed at:", address(disperse));
        vm.stopBroadcast();
    }
}
