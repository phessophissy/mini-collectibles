// Mini Collectibles Frontend
const CONTRACT_ADDRESS = "0x0000000000000000000000000000000000000000"; // Replace after deployment
const BASE_CHAIN_ID = "0x2105"; // Base Mainnet (8453)
const MINT_PRICE = "0.000012";

let provider = null;
let signer = null;
let contract = null;

// Contract ABI (minimal for minting)
const CONTRACT_ABI = [
    "function mint() external payable returns (uint256)",
    "function getMintPrice() external view returns (uint256)",
    "function totalSupply() external view returns (uint256)",
    "function balanceOf(address) external view returns (uint256)",
    "function getCollectibleType(uint256) external view returns (uint8)",
    "event CollectibleMinted(address indexed owner, uint256 indexed tokenId, uint8 collectibleType)"
];

// Rarity types
const RARITY_TYPES = ["Common", "Rare", "Epic", "Legendary"];
const RARITY_COLORS = ["#9ca3af", "#3b82f6", "#a855f7", "#f59e0b"];

// Connect wallet function
async function connectWallet() {
    if (typeof window.ethereum === "undefined") {
        alert("Please install MetaMask or another Web3 wallet!");
        return;
    }
    
    try {
        const accounts = await window.ethereum.request({
            method: "eth_requestAccounts"
        });
        
        await switchToBase();
        
        provider = new ethers.BrowserProvider(window.ethereum);
        signer = await provider.getSigner();
        contract = new ethers.Contract(CONTRACT_ADDRESS, CONTRACT_ABI, signer);
        
        updateUI(accounts[0]);
    } catch (error) {
        console.error("Connection failed:", error);
        alert("Failed to connect wallet");
    }
}
