# 🌺 Mini Collectibles

A beautiful NFT collectibles platform on Base Chain featuring a stunning **Metallic Engineering Theme** with transparent, colorful flower backgrounds.

![Theme](https://img.shields.io/badge/Theme-Pink%20Hibiscus-ff69b4)
![Base Chain](https://img.shields.io/badge/Chain-Base-0052FF)
![Solidity](https://img.shields.io/badge/Solidity-0.8.20-363636)
![License](https://img.shields.io/badge/License-MIT-green)

## 🌸 Features

- **Beautiful Metallic Engineering Theme** - Stunning metallic gradient with animated hibiscus flower background
- **Transparent Colorful Flowers** - Multi-layered SVG hibiscus flowers with varying opacity
- **Animated Background** - Gentle floating flower animation
- **Glassmorphism UI** - Modern frosted glass effect on cards
- **Four Rarity Tiers** - Common (50%), Rare (30%), Epic (15%), Legendary (5%)
- **Low Mint Price** - Only 0.000012 ETH per collectible
- **On-Chain Randomness** - Fair rarity distribution using block data

## 🎨 Theme Highlights

The Pink Hibiscus theme features:
- 🌺 **Pink gradient background** (#fce4ec → #f8bbd9 → #f48fb1)
- 🌸 **Multi-colored hibiscus flowers** in pink, purple, and coral
- ✨ **Transparent overlays** with 10-15% opacity
- 🎭 **Smooth animations** for floating flower effect
- 💎 **Glassmorphism cards** with backdrop blur

## 🚀 Quick Start

### Prerequisites
- [Foundry](https://book.getfoundry.sh/getting-started/installation)
- Node.js 18+
- MetaMask or compatible wallet

### Installation

```bash
# Clone the repository
git clone https://github.com/yourusername/mini-collectibles.git
cd mini-collectibles

# Install dependencies
forge install

# Build contracts
forge build

# Run tests
forge test
```

### Deploy to Base

```bash
# Set environment variables
export PRIVATE_KEY=your_private_key
export BASE_RPC_URL=https://mainnet.base.org

# Deploy
forge create src/MiniCollectibles.sol:MiniCollectibles \
  --rpc-url $BASE_RPC_URL \
  --private-key $PRIVATE_KEY
```

## 📁 Project Structure

```
mini-collectibles/
├── src/
│   └── MiniCollectibles.sol    # Main NFT contract
├── test/
│   └── MiniCollectibles.t.sol  # Foundry tests
├── frontend/
│   ├── index.html              # Main HTML
│   ├── styles.css              # Pink Hibiscus theme CSS
│   ├── app.js                  # Frontend logic
│   └── README.md               # Frontend docs
├── lib/                        # Dependencies
├── foundry.toml               # Foundry config
└── README.md                  # This file
```

## 🌺 Theme CSS Features

```css
/* Pink Hibiscus Background */
body {
    background: linear-gradient(135deg, #fce4ec 0%, #f8bbd9 50%, #f48fb1 100%);
}

/* Transparent Colorful Hibiscus Flowers */
body::before {
    background-image: url("hibiscus-pink.svg"), url("hibiscus-purple.svg"), url("hibiscus-coral.svg");
    opacity: 0.15;
    animation: floatFlowers 60s linear infinite;
}
```

## 🔗 Links

- [Base Chain](https://base.org)
- [OpenSea](https://opensea.io) - View your collectibles
- [BaseScan](https://basescan.org) - Verify transactions

## 🤝 Contributing

Contributions are welcome! Please read our [Contributing Guide](CONTRIBUTING.md) first.

## 📄 License

MIT License - see [LICENSE](LICENSE) for details.

---

Made with 🌺 and ❤️ for the Base Chain community
