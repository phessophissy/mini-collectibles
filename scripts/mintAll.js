// Mint Collectibles from All 50 Wallets
import { ethers } from "ethers";
import { readFileSync, writeFileSync } from "fs";
import dotenv from "dotenv";

dotenv.config();

const RPC_URL = process.env.RPC_URL || "https://mainnet.base.org";
const CONTRACT_ADDRESS = process.env.CONTRACT_ADDRESS || "0xEA3FD9Ff43E1C75ff600E9b18172280bd1b0A820";
const MINT_PRICE = "0.000012"; // ETH

const CONTRACT_ABI = [
    "function mint() external payable returns (uint256)",
    "function totalSupply() external view returns (uint256)",
    "function getCollectibleType(uint256) external view returns (uint8)",
    "event CollectibleMinted(address indexed owner, uint256 indexed tokenId, uint8 collectibleType)"
];

const RARITY_NAMES = ["COMMON", "RARE", "EPIC", "LEGENDARY"];

async function main() {
    console.log("🎨 Starting minting script for 50 wallets...\n");
    
    // Load wallets
    let walletsData;
    try {
        walletsData = JSON.parse(readFileSync("wallets.json", "utf8"));
    } catch (e) {
        console.error("❌ wallets.json not found. Run 'npm run generate-wallets' first.");
        process.exit(1);
    }
    
    // Setup provider
    const provider = new ethers.JsonRpcProvider(RPC_URL);
    
    // Check contract
    const code = await provider.getCode(CONTRACT_ADDRESS);
    if (code === "0x") {
        console.error(`❌ No contract found at ${CONTRACT_ADDRESS}`);
        process.exit(1);
    }
    
    console.log(`Contract: ${CONTRACT_ADDRESS}`);
    console.log(`Mint Price: ${MINT_PRICE} ETH`);
    console.log(`Wallets: ${walletsData.wallets.length}\n`);
    
    let successCount = 0;
    let failCount = 0;
    const mintResults = [];
    
    const rarityCount = { COMMON: 0, RARE: 0, EPIC: 0, LEGENDARY: 0 };
    
    for (const walletData of walletsData.wallets) {
        try {
            const wallet = new ethers.Wallet(walletData.privateKey, provider);
            const contract = new ethers.Contract(CONTRACT_ADDRESS, CONTRACT_ABI, wallet);
            
            // Check balance
            const balance = await provider.getBalance(wallet.address);
            const mintPriceWei = ethers.parseEther(MINT_PRICE);
            
            if (balance < mintPriceWei) {
                console.log(`⏭️  Wallet ${walletData.id}: Insufficient balance (${ethers.formatEther(balance)} ETH)`);
                failCount++;
                continue;
            }
            
            // Mint
            console.log(`🎲 Wallet ${walletData.id}: Minting...`);
            
            const tx = await contract.mint({
                value: mintPriceWei
            });
            
            const receipt = await tx.wait();
            
            // Parse the CollectibleMinted event
            let tokenId = null;
            let rarity = null;
            
            for (const log of receipt.logs) {
                try {
                    const parsed = contract.interface.parseLog(log);
                    if (parsed && parsed.name === "CollectibleMinted") {
                        tokenId = parsed.args[1].toString();
                        rarity = RARITY_NAMES[Number(parsed.args[2])];
                        rarityCount[rarity]++;
                        break;
                    }
                } catch (e) {}
            }
            
            console.log(`✅ Wallet ${walletData.id}: Minted Token #${tokenId} (${rarity})`);
            
            mintResults.push({
                walletId: walletData.id,
                address: walletData.address,
                tokenId: tokenId,
                rarity: rarity,
                txHash: receipt.hash
            });
            
            successCount++;
            
            // Small delay
            await new Promise(r => setTimeout(r, 300));
            
        } catch (error) {
            console.error(`❌ Wallet ${walletData.id} failed: ${error.message}`);
            failCount++;
        }
    }
    
    // Save results
    const results = {
        timestamp: new Date().toISOString(),
        contract: CONTRACT_ADDRESS,
        totalMinted: successCount,
        rarityDistribution: rarityCount,
        mints: mintResults
    };
    
    writeFileSync("mint-results.json", JSON.stringify(results, null, 2));
    
    console.log(`\n========================================`);
    console.log(`           MINTING COMPLETE`);
    console.log(`========================================`);
    console.log(`✅ Success: ${successCount}/${walletsData.wallets.length}`);
    console.log(`❌ Failed: ${failCount}/${walletsData.wallets.length}`);
    console.log(`\n📊 Rarity Distribution:`);
    console.log(`   COMMON:    ${rarityCount.COMMON}`);
    console.log(`   RARE:      ${rarityCount.RARE}`);
    console.log(`   EPIC:      ${rarityCount.EPIC}`);
    console.log(`   LEGENDARY: ${rarityCount.LEGENDARY}`);
    console.log(`========================================`);
    console.log(`\n📄 Results saved to mint-results.json`);
}

main().catch(console.error);
