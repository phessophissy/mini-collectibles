# Mini Collectibles Frontend

A web3 frontend for minting collectibles on Base Chain.

## Features

- Connect wallet (MetaMask, etc.)
- Auto-switch to Base Chain
- Mint collectibles for 0.000012 ETH
- View rarity of minted collectibles
- Track collection stats

## Running Locally

```bash
cd frontend
npx serve .
```

Then open http://localhost:3000 in your browser.

## Deployment

This is a static site that can be deployed to:
- Vercel
- Netlify
- GitHub Pages
- IPFS

## Configuration

Update `CONTRACT_ADDRESS` in `app.js` with your deployed contract address.
