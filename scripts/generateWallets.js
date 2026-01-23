// Generate 50 Test Wallets for Minting
import { Wallet } from "ethers";
import { writeFileSync } from "fs";

const WALLET_COUNT = 50;

console.log("🔐 Generating 50 test wallets...\n");

const wallets = [];

for (let i = 0; i < WALLET_COUNT; i++) {
    const wallet = Wallet.createRandom();
    wallets.push({
        id: i + 1,
        address: wallet.address,
        privateKey: wallet.privateKey,
        mnemonic: wallet.mnemonic.phrase
    });
    console.log(`Wallet ${i + 1}: ${wallet.address}`);
}

// Save to JSON file
const output = {
    generated: new Date().toISOString(),
    count: WALLET_COUNT,
    wallets: wallets
};

writeFileSync("wallets.json", JSON.stringify(output, null, 2));

console.log("\n✅ 50 wallets generated and saved to wallets.json");
console.log("⚠️  KEEP THIS FILE SECURE - Contains private keys!");
