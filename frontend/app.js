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
