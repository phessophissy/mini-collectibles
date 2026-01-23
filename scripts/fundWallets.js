// Fund 50 Wallets from Main Funder Wallet
import { ethers } from "ethers";
import { readFileSync } from "fs";
import dotenv from "dotenv";

dotenv.config();

const RPC_URL = process.env.RPC_URL || "https://mainnet.base.org";
const FUNDER_PRIVATE_KEY = process.env.FUNDER_PRIVATE_KEY;
const FUND_AMOUNT = process.env.FUND_AMOUNT || "0.00005"; // ETH per wallet

if (!FUNDER_PRIVATE_KEY) {
    console.error("❌ FUNDER_PRIVATE_KEY not set in .env");
    process.exit(1);
}

async function main() {
    console.log("💰 Starting wallet funding script...\n");
    
    // Load wallets
    let walletsData;
    try {
        walletsData = JSON.parse(readFileSync("wallets.json", "utf8"));
    } catch (e) {
        console.error("❌ wallets.json not found. Run 'npm run generate-wallets' first.");
        process.exit(1);
    }
    
    // Setup provider and funder wallet
    const provider = new ethers.JsonRpcProvider(RPC_URL);
    const funder = new ethers.Wallet(FUNDER_PRIVATE_KEY, provider);
    
    console.log(`Funder Address: ${funder.address}`);
    console.log(`Expected Funder: 0x30d99e4e396D0986853921c4F1eF0e4a93a9aAcd`);
    
    const funderBalance = await provider.getBalance(funder.address);
    console.log(`Funder Balance: ${ethers.formatEther(funderBalance)} ETH`);
    
    const fundAmountWei = ethers.parseEther(FUND_AMOUNT);
    const totalNeeded = fundAmountWei * BigInt(walletsData.wallets.length);
    
    console.log(`\nFunding ${walletsData.wallets.length} wallets with ${FUND_AMOUNT} ETH each`);
    console.log(`Total needed: ${ethers.formatEther(totalNeeded)} ETH\n`);
    
    if (funderBalance < totalNeeded) {
        console.error(`❌ Insufficient balance! Need ${ethers.formatEther(totalNeeded)} ETH`);
        process.exit(1);
    }
    
    let successCount = 0;
    let failCount = 0;
    
    for (const wallet of walletsData.wallets) {
        try {
            // Check if already funded
            const balance = await provider.getBalance(wallet.address);
            if (balance >= fundAmountWei) {
                console.log(`⏭️  Wallet ${wallet.id} already funded: ${wallet.address}`);
                successCount++;
                continue;
            }
            
            // Send funds
            const tx = await funder.sendTransaction({
                to: wallet.address,
                value: fundAmountWei
            });
            
            console.log(`📤 Wallet ${wallet.id}: Sending ${FUND_AMOUNT} ETH... (tx: ${tx.hash.slice(0, 10)}...)`);
            await tx.wait();
            console.log(`✅ Wallet ${wallet.id}: Funded successfully`);
            successCount++;
            
            // Small delay to avoid rate limiting
            await new Promise(r => setTimeout(r, 500));
            
        } catch (error) {
            console.error(`❌ Wallet ${wallet.id} failed: ${error.message}`);
            failCount++;
        }
    }
    
    console.log(`\n========================================`);
    console.log(`✅ Funded: ${successCount}/${walletsData.wallets.length}`);
    console.log(`❌ Failed: ${failCount}/${walletsData.wallets.length}`);
    console.log(`========================================`);
}

main().catch(console.error);
