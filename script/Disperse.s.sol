// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";
import "forge-std/console.sol";

interface IDisperse {
    function disperseEther(address[] calldata recipients, uint256[] calldata values) external payable;
}

contract DisperseSepoliaScript is Script {
    address constant DISPERSE = 0xd15fE25eD0Dba12fE05e7029C88b10C25e8880E3;
    uint256 constant AMOUNT_PER_RECIPIENT = 10 ether;

    function run() external {
        string memory raw = vm.readFile("students.txt");
        string[] memory lines = vm.split(raw, "\n");

        address[] memory parsed = new address[](lines.length);
        uint256 uniqueCount = 0;

        for (uint256 i = 0; i < lines.length; i++) {
            string memory line = vm.trim(lines[i]);
            if (bytes(line).length == 0) continue;

            address recipient = vm.parseAddress(line);

            bool alreadySeen = false;
            for (uint256 j = 0; j < uniqueCount; j++) {
                if (parsed[j] == recipient) {
                    alreadySeen = true;
                    break;
                }
            }

            if (alreadySeen) {
                console.log("duplicate skipped:");
                console.logAddress(recipient);
                continue;
            }

            parsed[uniqueCount] = recipient;
            uniqueCount++;
        }

        require(uniqueCount > 0, "No recipients found");

        address[] memory recipients = new address[](uniqueCount);
        uint256[] memory values = new uint256[](uniqueCount);

        uint256 total = 0;
        for (uint256 i = 0; i < uniqueCount; i++) {
            recipients[i] = parsed[i];
            values[i] = AMOUNT_PER_RECIPIENT;
            total += AMOUNT_PER_RECIPIENT;

            console.log("recipient index", i);
            console.logAddress(recipients[i]);
            console.log("value", values[i]);
        }

        console.log("unique recipient count", uniqueCount);
        console.log("amount per recipient", AMOUNT_PER_RECIPIENT);
        console.log("total", total);
        console.logAddress(DISPERSE);

        vm.startBroadcast();
        IDisperse(DISPERSE).disperseEther{value: total}(recipients, values);
        vm.stopBroadcast();
    }
}
