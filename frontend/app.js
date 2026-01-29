// Mini Collectibles Frontend
const CONTRACT_ADDRESS = "0xEA3FD9Ff43E1C75ff600E9b18172280bd1b0A820"; // Deployed on Base Mainnet
const BASE_CHAIN_ID = "0x2105"; // Base Mainnet (8453)
const MINT_PRICE = "0.000012";

let provider = null;
let signer = null;
let contract = null;

// Rarity types and colors
const RARITY_TYPES = ["Common", "Rare", "Epic", "Legendary"];
const RARITY_COLORS = ["#9ca3af", "#3b82f6", "#a855f7", "#f59e0b"];

// Contract ABI (minimal for minting)
const CONTRACT_ABI = [
    "function mint() external payable returns (uint256)",
    "function getMintPrice() external view returns (uint256)",
    "function totalSupply() external view returns (uint256)",
    "function balanceOf(address) external view returns (uint256)",
    "function getCollectibleType(uint256) external view returns (uint8)",
    "event CollectibleMinted(address indexed owner, uint256 indexed tokenId, uint8 collectibleType)"
];

// Connect wallet
async function connectWallet() {
    if (typeof window.ethereum === "undefined") {
        alert("Please install MetaMask!");
        return;
    }

    try {
        const accounts = await window.ethereum.request({
            method: "eth_requestAccounts"
        });

        await switchToBase();

        provider = new ethers.BrowserProvider(window.ethereum);
        const network = await provider.getNetwork();
        if (network.chainId !== 8453n) {
            alert("Please switch to Base Mainnet");
            return;
        }
        signer = await provider.getSigner();
        contract = new ethers.Contract(CONTRACT_ADDRESS, CONTRACT_ABI, signer);

        updateUI(accounts[0]);
    } catch (error) {
        console.error("Connection failed:", error);
        alert("Failed to connect: " + error.message);
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

// Show mint success modal
function showMintSuccess(tokenId, collectibleType) {
    const modal = document.getElementById("success-modal");
    const rarityName = RARITY_TYPES[collectibleType];
    const rarityColor = RARITY_COLORS[collectibleType];

    document.getElementById("minted-token-id").textContent = tokenId.toString();
    document.getElementById("minted-rarity").textContent = rarityName;
    document.getElementById("minted-rarity").style.color = rarityColor;

    modal.style.display = "flex";
}

// Close modal
function closeModal() {
    document.getElementById("success-modal").style.display = "none";
}

// Event listeners
document.addEventListener("DOMContentLoaded", () => {
    document.getElementById("connect-btn").addEventListener("click", connectWallet);
    document.getElementById("mint-btn")?.addEventListener("click", mintCollectible);
    document.getElementById("close-modal")?.addEventListener("click", closeModal);
});

// Floating Engineering Tools Animation
const emojis = ['🔧', '🔨', '⚙️', '🪛', '🔩', '🛠️', '⚡', '🔌', '💡', '🔬', '🔭', '🧲', '🧪', '📐', '📏', '✏️', '🪚', '⛏️', '🎚️', '🔋', '⚗️', '🔗', '🪝', '🧰', '🔶', '🔷', '⬡', '⬢', '◈', '◇'];

function createFloatingEmoji() {
    const container = document.getElementById('emoji-container');
    if (!container) return;

    const emoji = document.createElement('span');
    emoji.className = 'floating-emoji';
    emoji.textContent = emojis[Math.floor(Math.random() * emojis.length)];

    // Random position
    emoji.style.left = Math.random() * 100 + '%';

    // Random size
    const size = 1 + Math.random() * 2;
    emoji.style.fontSize = size + 'rem';

    // Random animation duration
    const duration = 8 + Math.random() * 12;
    emoji.style.animationDuration = duration + 's';

    // Random delay
    emoji.style.animationDelay = Math.random() * 5 + 's';

    container.appendChild(emoji);

    // Remove after animation
    setTimeout(() => {
        emoji.remove();
    }, (duration + 5) * 1000);
}

// Start creating emojis
setInterval(createFloatingEmoji, 500);

// Create initial batch
for (let i = 0; i < 15; i++) {
    setTimeout(createFloatingEmoji, i * 200);
}

// Theme Toggle Functionality
function initThemeToggle() {
    const lightBtn = document.getElementById('light-btn');
    const darkBtn = document.getElementById('dark-btn');
    const body = document.body;

    // Load saved theme preference
    const savedTheme = localStorage.getItem('theme') || 'light';
    applyTheme(savedTheme);

    lightBtn.addEventListener('click', () => applyTheme('light'));
    darkBtn.addEventListener('click', () => applyTheme('dark'));

    function applyTheme(theme) {
        body.classList.remove('light-mode', 'dark-mode');
        body.classList.add(theme + '-mode');
        lightBtn.classList.toggle('active', theme === 'light');
        darkBtn.classList.toggle('active', theme === 'dark');
        localStorage.setItem('theme', theme);
    }
}

// Initialize theme toggle on DOM load
document.addEventListener('DOMContentLoaded', initThemeToggle);
