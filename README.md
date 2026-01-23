# 🎨 Mini Collectibles

A collectible NFT platform on Base Chain (mainnet) where users can mint unique collectibles with different rarities.

## Features

- **Mint Collectibles**: Mint for only 0.000012 ETH
- **Four Rarities**: Common (50%), Rare (30%), Epic (15%), Legendary (5%)
- **Base Chain**: Deployed on Base mainnet for low gas fees
- **ERC-721 Compatible**: Transfer, approve, and manage your collectibles
- **Web3 Frontend**: Beautiful interface to mint and view your collection

## Quick Start

### Smart Contracts

```bash
# Install Foundry
curl -L https://foundry.paradigm.xyz | bash
foundryup

# Build
forge build

# Test
forge test

# Deploy to Base
forge script script/Deploy.s.sol --rpc-url base --broadcast
```

### Frontend

```bash
cd frontend
npx serve .
```

## Contract Details

- **Network**: Base Mainnet (Chain ID: 8453)
- **Mint Price**: 0.000012 ETH
- **Token Standard**: ERC-721 compatible
- **Solidity Version**: 0.8.24

## Rarity Distribution

| Rarity    | Chance | Color   |
|-----------|--------|---------|
| Common    | 50%    | Gray    |
| Rare      | 30%    | Blue    |
| Epic      | 15%    | Purple  |
| Legendary | 5%     | Gold    |

## Project Structure

```
mini-collectibles/
├── src/
│   ├── MiniCollectibles.sol    # Main NFT contract
│   └── ICollectible.sol        # Interface
├── script/
│   └── Deploy.s.sol            # Deployment script
├── test/
│   └── MiniCollectibles.t.sol  # Tests
├── frontend/
│   ├── index.html              # Web interface
│   ├── styles.css              # Styling
│   └── app.js                  # Web3 logic
└── foundry.toml                # Foundry config
```

## License

MIT License - see [LICENSE](LICENSE)
