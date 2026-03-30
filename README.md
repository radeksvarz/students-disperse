# 🚀 Disperse.app Automation Script

A streamlined Foundry-based solution for distributing ETH to multiple recipients on the Sepolia testnet using [Disperse.app](https://disperse.app/).

## 📋 Overview

This project automates the process of sending a fixed amount of ETH (default: 10 ETH) to a list of students listed in `students.txt`. It includes a programmatic impact test that allows you to simulate the distribution on a Sepolia fork and inspect the state changes before broadcasting for real.

## 🛠️ Prerequisites

Ensure you have [Foundry](https://book.getfoundry.sh/getting-started/installation) installed:

```bash
curl -L https://foundry.parity.io | bash
foundryup
```

## ⚙️ Configuration

1. **Student List**: Edit `students.txt` and add one recipient address per line.
   - The script automatically handles duplicates and empty lines.
2. **Amount**: The default amount per recipient is defined in `script/Disperse.s.sol` as `AMOUNT_PER_RECIPIENT`.
3. **RPC URL**: The Sepolia RPC endpoint is pre-configured in `foundry.toml`.

---

## 🧪 Running the Impact Test (Simulation)

Before sending real ETH, use the impact test to see exactly how balances will change on a Sepolia fork. This test uses Forge's state diff recording to show exactly who gets what.

```bash
forge test --match-test test_ExecutionImpact -vv
```

---

## ⚡ Executing the Script (Broadcast)

To perform the actual distribution on Sepolia, run the following command. You will need a private key with sufficient Sepolia ETH.

### 1. Dry Run (Local Simulation)
```bash
forge script script/Disperse.s.sol --rpc-url sepolia --account <ACCOUNT_NAME> -vvvv
```

### 2. Live Broadcast
```bash
forge script script/Disperse.s.sol --rpc-url sepolia --account <ACCOUNT_NAME> --broadcast
```

---

## 🔍 Verification

The script interacts with the Disperse.app contract on Sepolia: 
`0xd15fE25eD0Dba12fE05e7029C88b10C25e8880E3`

You can verify the results on [Sepolia Etherscan](https://sepolia.etherscan.io/address/0xd15fE25eD0Dba12fE05e7029C88b10C25e8880E3).

---

## 📝 Troubleshooting

- **Lack of Funds**: The script requires `total_recipients * 10 ETH` plus gas. Ensure your broadcasting wallet is well-funded.
- **Simulation Error**: If the simulation fails with "lack of funds", it means your wallet doesn't have enough ETH to cover the transaction. The Impact Test overcomes this by using `vm.deal` locally.
