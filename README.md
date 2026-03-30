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
3. **Chain Configuration**:
   - RPC endpoints (like `sepolia` or `lasna`) are configured in `foundry.toml`.
   - Contract addresses are managed in `disperse.toml` using the **Chain ID** as the key.

### ➕ Adding a New Chain
To support a new network:
1. Add the RPC endpoint to `foundry.toml` under `[rpc_endpoints]`.
2. Add the Disperse contract address to `disperse.toml` using the network's **Chain ID**:
   ```toml
   "12345" = "0x..." # My New Chain
   ```

---

## 🧪 Running the Impact Test (Simulation)

Before sending real ETH, use the impact test to see exactly how balances will change on a fork.

```bash
# For Sepolia
forge test --match-test test_ExecutionImpact -vv --rpc-url sepolia
```

---

## ⚡ Executing the Script (Broadcast)

To perform the actual distribution, run the following command.

### 1. Dry Run (Local Simulation)
```bash
# For Sepolia
forge script script/Disperse.s.sol --rpc-url sepolia --account <ACCOUNT_NAME> -vvvv

# For Lasna
forge script script/Disperse.s.sol --rpc-url lasna --account <ACCOUNT_NAME> -vvvv
```

### 2. Live Broadcast
```bash
forge script script/Disperse.s.sol --rpc-url <NETWORK_NAME> --account <ACCOUNT_NAME> --broadcast
```

---

## 🔍 Verification

The script interacts with Disperse.app contracts. Addresses are stored in `disperse.toml`:
- **Sepolia (11155111)**: `0xd15fE25eD0Dba12fE05e7029C88b10C25e8880E3`
- **Lasna (5318007)**: `0xcB56F57BF341c459cC479c9E08FCbC92E85d37B6`

---

## 📝 Troubleshooting

- **Lack of Funds**: The script requires `total_recipients * 10 ETH` plus gas. Ensure your broadcasting wallet is well-funded.
- **Simulation Error**: If the simulation fails with "lack of funds", it means your wallet doesn't have enough ETH to cover the transaction. The Impact Test overcomes this by using `vm.deal` locally.
