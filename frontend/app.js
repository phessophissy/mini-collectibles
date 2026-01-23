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

// Switch to Base Chain
async function switchToBase() {
    try {
        await window.ethereum.request({
            method: "wallet_switchEthereumChain",
            params: [{ chainId: BASE_CHAIN_ID }]
        });
    } catch (switchError) {
        if (switchError.code === 4902) {
            await window.ethereum.request({
                method: "wallet_addEthereumChain",
                params: [{
                    chainId: BASE_CHAIN_ID,
                    chainName: "Base",
                    nativeCurrency: { name: "Ether", symbol: "ETH", decimals: 18 },
                    rpcUrls: ["https://mainnet.base.org"],
                    blockExplorerUrls: ["https://basescan.org"]
                }]
            });
        }
    }
}

// Mint collectible
async function mintCollectible() {
    if (!contract) {
        alert("Please connect your wallet first!");
        return;
    }
    
    try {
        const mintBtn = document.getElementById("mint-btn");
        mintBtn.disabled = true;
        mintBtn.textContent = "Minting...";
        
        const tx = await contract.mint({
            value: ethers.parseEther(MINT_PRICE)
        });
        
        mintBtn.textContent = "Confirming...";
        const receipt = await tx.wait();
        
        // Parse event to get token info
        const event = receipt.logs.find(log => log.fragment?.name === "CollectibleMinted");
        if (event) {
            const tokenId = event.args[1];
            const collectibleType = event.args[2];
            showMintSuccess(tokenId, collectibleType);
        }
        
        await updateStats();
        mintBtn.disabled = false;
        mintBtn.textContent = "Mint Collectible (0.000012 ETH)";
    } catch (error) {
        console.error("Mint failed:", error);
        alert("Minting failed: " + error.message);
        const mintBtn = document.getElementById("mint-btn");
        mintBtn.disabled = false;
        mintBtn.textContent = "Mint Collectible (0.000012 ETH)";
    }
}

// Update UI after connection
function updateUI(address) {
    document.getElementById("connect-btn").textContent = "Connected";
    document.getElementById("connect-btn").disabled = true;
    document.getElementById("wallet-address").textContent = 
        address.slice(0, 6) + "..." + address.slice(-4);
    
    document.getElementById("mint-section").style.display = "block";
    updateStats();
}

// Update stats display
async function updateStats() {
    if (!contract) return;
    
    try {
        const totalSupply = await contract.totalSupply();
        const userAddress = await signer.getAddress();
        const userBalance = await contract.balanceOf(userAddress);
        
        document.getElementById("total-supply").textContent = totalSupply.toString();
        document.getElementById("your-balance").textContent = userBalance.toString();
    } catch (error) {
        console.error("Failed to fetch stats:", error);
    }
}
