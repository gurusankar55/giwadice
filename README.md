# 🎲 GIWA Dice

A tiny on-chain dice game on **GIWA Sepolia** (Upbit's Ethereum L2 testnet).

Pick a number from 1 to 6 and roll. Every roll is a real transaction on GIWA Sepolia. If the dice lands on your number, you win.

## Features
- One-click roll, result read from the on-chain `Rolled` event
- Your stats: plays, wins, plays today, daily streak, best streak, win rate
- Public leaderboard (top 10 by wins)
- Works with Rabby, MetaMask and other EIP-6963 wallets
- Auto-adds / switches to the GIWA Sepolia network
- Single HTML file, no build step

## Contract
- Network: GIWA Sepolia (chain ID 91342)
- Address: [`0x33f96c54cb80b10139b529fbaa86a660eda2ff20`](https://sepolia-explorer.giwa.io/address/0x33f96c54cb80b10139b529fbaa86a660eda2ff20?tab=contract) (verified)
- Source: [`contracts/GiwaDice.sol`](contracts/GiwaDice.sol)
- Compiler: solc 0.8.34, EVM cancun, optimizer off

## Play
Open the live page (GitHub Pages) or `index.html` in a browser with a wallet extension. You need a little GIWA Sepolia test ETH for gas:
- Bridge Sepolia ETH: https://sepolia-bridge.giwa.io/
- Faucet: https://faucet.giwa.io/

## Network details
| | |
|---|---|
| RPC | https://sepolia-rpc.giwa.io |
| Chain ID | 91342 |
| Currency | ETH |
| Explorer | https://sepolia-explorer.giwa.io |

## Note
Testnet only. The randomness uses `prevrandao`, timestamp, sender and a nonce, which is fine for a game with no real money but must not be used for real-value bets.

## License
MIT
