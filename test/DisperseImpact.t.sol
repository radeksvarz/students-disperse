// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import {DisperseSepoliaScript} from "../script/Disperse.s.sol";

contract DisperseImpactTest is Test {
    DisperseSepoliaScript public script;
    address constant DISPERSE_ADDR = 0xd15fE25eD0Dba12fE05e7029C88b10C25e8880E3;
    // Default Forge Broadcaster
    address constant DEFAULT_BROADCASTER = 0x1804c8AB1F12E6bbf3894d4083f33e07309d1f38;

    function setUp() public {
        vm.createSelectFork(vm.rpcUrl("sepolia"));
        script = new DisperseSepoliaScript();

        // Give ETH to the default broadcaster so the script can spend it
        vm.deal(DEFAULT_BROADCASTER, 100 ether);
    }

    function test_ExecutionImpact() public {
        uint256 distBalBefore = DEFAULT_BROADCASTER.balance;

        vm.startStateDiffRecording();
        script.run();
        Vm.AccountAccess[] memory accesses = vm.stopAndReturnStateDiff();

        uint256 distBalAfter = DEFAULT_BROADCASTER.balance;

        console.log("");
        console.log("================ PROGRAMMATIC STATE DIFF ================");
        console.log("DISTRIBUTOR (Forge Default Sender):");
        console.log("  Address:       ", DEFAULT_BROADCASTER);
        console.log("  Initial Bal:   ", distBalBefore);
        console.log("  Final Bal:     ", distBalAfter);
        console.log("  Total Sent:    ", (distBalBefore - distBalAfter) / 1 ether, "ETH");

        for (uint256 i = 0; i < accesses.length; i++) {
            Vm.AccountAccess memory access = accesses[i];

            bool isDisperse = access.account == DISPERSE_ADDR;
            bool isDistributor = access.account == DEFAULT_BROADCASTER;
            bool balanceChanged = access.oldBalance != access.newBalance;

            if (isDisperse || isDistributor || balanceChanged) {
                console.log("");
                console.log(
                    "Account:",
                    access.account,
                    isDisperse ? "[DISPERSE CONTRACT]" : (isDistributor ? "[DISTRIBUTOR]" : "")
                );

                if (balanceChanged) {
                    console.log("  Balance Change:");
                    console.log("    Before:", access.oldBalance);
                    console.log("    After: ", access.newBalance);
                } else {
                    console.log("  (Net balance unchanged)");
                }
            }
        }
        console.log("========================================================");
    }
}
