#!/bin/bash
# Script to generate 30+ commits for Metallic Engineering Theme transformation
set -e

cd /home/thee1/mini-collectibles

# Helper function to commit
commit() {
    git add -A
    git commit -m "$1"
}

# Restore stashed changes first
git stash pop

# =====================
# COMMIT 1: Update CSS comment header
# =====================
sed -i '1s/.*/\/* Mini Collectibles - Metallic Engineering Theme *\//' frontend/styles.css
commit "refactor(theme): update CSS header to Metallic Engineering Theme"

# =====================
# COMMIT 2: Add metallic CSS variables
# =====================
sed -i '8a\    /* Metallic Color Palette - Primary */\n    --metallic-dark: #1E2022;\n    --metallic-gunmetal: #2C3539;' frontend/styles.css
commit "feat(theme): add primary metallic color CSS variables"

# =====================
# COMMIT 3: Add metallic accent variables
# =====================
sed -i '/--metallic-gunmetal/a\    --metallic-steel: #43464B;\n    --metallic-chrome: #71797E;' frontend/styles.css
commit "feat(theme): add metallic steel and chrome color variables"

# =====================
# COMMIT 4: Add metallic light tones
# =====================
sed -i '/--metallic-chrome/a\    --metallic-silver: #C0C0C0;\n    --metallic-platinum: #E5E4E2;' frontend/styles.css
commit "feat(theme): add silver and platinum color variables"

# =====================
# COMMIT 5: Add metallic blue accent
# =====================
sed -i '/--metallic-platinum/a\    --metallic-blue: #5DA9E9;' frontend/styles.css
commit "feat(theme): add metallic blue accent color"

# =====================
# COMMIT 6: Add metallic gold color
# =====================
sed -i '/--metallic-blue/a\    --metallic-gold: #CFB53B;' frontend/styles.css
commit "feat(theme): add metallic gold color for legendary rarity"

# =====================
# COMMIT 7: Add bronze color
# =====================
sed -i '/--metallic-gold/a\    --metallic-bronze: #CD7F32;' frontend/styles.css
commit "feat(theme): add metallic bronze accent color"

# =====================
# COMMIT 8: Add copper color
# =====================
sed -i '/--metallic-bronze/a\    --metallic-copper: #B87333;' frontend/styles.css
commit "feat(theme): add metallic copper accent color"

# =====================
# COMMIT 9: Update body background gradient
# =====================
sed -i 's/background: linear-gradient(135deg, #2d2d2d 0%, #3d3d3d 50%, #4a4a4a 100%);/background: linear-gradient(135deg, var(--metallic-dark) 0%, var(--metallic-gunmetal) 50%, var(--metallic-steel) 100%);/' frontend/styles.css
commit "style(theme): update body background to metallic gradient"

# =====================
# COMMIT 10: Update text color to platinum
# =====================
sed -i 's/color: #e0e0e0;/color: var(--metallic-platinum);/' frontend/styles.css
commit "style(theme): update body text color to platinum"

# =====================
# COMMIT 11: Update header gradient
# =====================
sed -i "s/background: linear-gradient(90deg, #9e9e9e, #bdbdbd, #757575);/background: linear-gradient(90deg, var(--metallic-silver), var(--metallic-platinum), var(--metallic-chrome), var(--metallic-silver));/" frontend/styles.css
commit "style(header): apply metallic shimmer gradient to header"

# =====================
# COMMIT 12: Add shimmer animation
# =====================
cat >> frontend/styles.css << 'EOF'

/* Metallic Shimmer Animation */
@keyframes metallicShimmer {
    0% { background-position: 0% center; }
    100% { background-position: 200% center; }
}
EOF
commit "feat(animation): add metallic shimmer keyframe animation"

# =====================
# COMMIT 13: Apply shimmer to header
# =====================
sed -i '/header h1 {/,/}/ { /text-shadow/a\    animation: metallicShimmer 3s linear infinite;\n    background-size: 200% auto;' frontend/styles.css
commit "feat(header): apply shimmer animation to header title"

# =====================
# COMMIT 14: Update subtitle color
# =====================
sed -i 's/.subtitle { color: #9e9e9e; }/.subtitle { color: var(--metallic-chrome); }/' frontend/styles.css
commit "style(header): update subtitle to metallic chrome color"

# =====================
# COMMIT 15: Update connect button gradient
# =====================
sed -i 's/#connect-btn { background: linear-gradient(90deg, #616161, #757575);/#connect-btn { background: linear-gradient(180deg, var(--metallic-chrome) 0%, var(--metallic-steel) 50%, var(--metallic-gunmetal) 100%);/' frontend/styles.css
commit "style(button): apply metallic gradient to connect button"

# =====================
# COMMIT 16: Update connect button border
# =====================
sed -i 's/border-color: #757575;/border-color: var(--metallic-silver);/' frontend/styles.css
commit "style(button): update connect button border to silver"

# =====================
# COMMIT 17: Update wallet address styling
# =====================
sed -i 's/#wallet-address { background: rgba(158, 158, 158, 0.2); color: #bdbdbd; }/#wallet-address { background: rgba(192, 192, 192, 0.1); color: var(--metallic-silver); border: 1px solid rgba(192, 192, 192, 0.2); }/' frontend/styles.css
commit "style(wallet): apply metallic styling to wallet address"

# =====================
# COMMIT 18: Update mint card background
# =====================
sed -i 's/.mint-card { background: linear-gradient(135deg, rgba(66, 66, 66, 0.95) 0%, rgba(48, 48, 48, 0.98) 100%);/.mint-card { background: linear-gradient(135deg, rgba(67, 70, 75, 0.9) 0%, rgba(44, 53, 57, 0.95) 100%);/' frontend/styles.css
commit "style(card): update mint card with metallic background"

# =====================
# COMMIT 19: Update mint card border
# =====================
sed -i 's/border-color: #616161;/border-color: var(--metallic-chrome);/' frontend/styles.css
commit "style(card): update mint card border to chrome color"

# =====================
# COMMIT 20: Add inset shadow to cards
# =====================
sed -i 's/.mint-card { box-shadow: 0 0 30px rgba(0, 0, 0, 0.5), inset 0 0 20px rgba(255, 255, 255, 0.05); }/.mint-card { box-shadow: 0 0 30px rgba(0, 0, 0, 0.5), inset 0 1px 0 rgba(255,255,255,0.1); }/' frontend/styles.css
commit "style(card): add metallic inset highlight to cards"

# =====================
# COMMIT 21: Update mint button gradient
# =====================
sed -i 's/#mint-btn { background: linear-gradient(90deg, #616161, #424242);/#mint-btn { background: linear-gradient(180deg, var(--metallic-blue) 0%, #4A8BC9 50%, #3A6B99 100%);/' frontend/styles.css
commit "style(button): apply metallic blue gradient to mint button"

# =====================
# COMMIT 22: Update mint button border
# =====================
sed -i '/#mint-btn/s/border-color: #757575;/border-color: var(--metallic-blue);/' frontend/styles.css
commit "style(button): update mint button border to metallic blue"

# =====================
# COMMIT 23: Update stat card background
# =====================
sed -i 's/.stat { background: rgba(66, 66, 66, 0.9);/.stat { background: rgba(67, 70, 75, 0.8);/' frontend/styles.css
commit "style(stats): update stat card with metallic background"

# =====================
# COMMIT 24: Update stat label color
# =====================
sed -i 's/.stat-label { color: #9e9e9e; }/.stat-label { color: var(--metallic-chrome); }/' frontend/styles.css
commit "style(stats): update stat label to chrome color"

# =====================
# COMMIT 25: Update stat value color
# =====================
sed -i 's/.stat-value { color: #e0e0e0; }/.stat-value { color: var(--metallic-platinum); }/' frontend/styles.css
commit "style(stats): update stat value to platinum color"

# =====================
# COMMIT 26: Update modal background
# =====================
sed -i 's/.modal { background: rgba(33, 33, 33, 0.95); }/.modal { background: rgba(30, 32, 34, 0.95); }/' frontend/styles.css
commit "style(modal): update modal overlay to metallic dark"

# =====================
# COMMIT 27: Update modal content gradient
# =====================
sed -i 's/.modal-content { background: linear-gradient(135deg, #424242 0%, #303030 100%);/.modal-content { background: linear-gradient(135deg, var(--metallic-steel) 0%, var(--metallic-gunmetal) 100%);/' frontend/styles.css
commit "style(modal): apply metallic gradient to modal content"

# =====================
# COMMIT 28: Update legendary rarity to gold
# =====================
sed -i 's/.rarity.legendary { background: rgba(255, 215, 0, 0.2); color: #ffd700; border-color: #ffb300; }/.rarity.legendary { background: rgba(207, 181, 59, 0.2); color: var(--metallic-gold); border-color: var(--metallic-gold); }/' frontend/styles.css
commit "style(rarity): update legendary rarity to metallic gold"

# =====================
# COMMIT 29: Update rare rarity to metallic blue
# =====================
sed -i 's/.rarity.rare { background: rgba(100, 181, 246, 0.2); color: #64b5f6;/.rarity.rare { background: rgba(93, 169, 233, 0.2); color: var(--metallic-blue);/' frontend/styles.css
commit "style(rarity): update rare rarity to metallic blue"

# =====================
# COMMIT 30: Update scrollbar to metallic
# =====================
sed -i 's/::-webkit-scrollbar-thumb { background: #616161;/::-webkit-scrollbar-thumb { background: var(--metallic-chrome);/' frontend/styles.css
commit "style(scrollbar): apply metallic chrome to scrollbar"

# =====================
# COMMIT 31: Update selection color
# =====================
sed -i 's/::selection { background: rgba(158, 158, 158, 0.4);/::selection { background: rgba(93, 169, 233, 0.4);/' frontend/styles.css
commit "style(selection): update selection to metallic blue"

# =====================
# COMMIT 32: Update focus ring
# =====================
sed -i 's/button:focus { outline: 2px solid #9e9e9e;/button:focus { outline: 2px solid var(--metallic-blue);/' frontend/styles.css
commit "style(a11y): update focus ring to metallic blue"

# =====================
# COMMIT 33: Update link colors
# =====================
sed -i 's/a { color: #9e9e9e; } a:hover { color: #bdbdbd; }/a { color: var(--metallic-blue); } a:hover { color: #7BBFF0; }/' frontend/styles.css
commit "style(links): apply metallic blue to links"

# =====================
# COMMIT 34: Update emoji array to engineering tools
# =====================
sed -i "s/const emojis = \[.*\];/const emojis = ['🔧', '🔨', '⚙️', '🪛', '🔩', '🛠️', '⚡', '🔌', '💡', '🔬', '🔭', '🧲', '🧪', '📐', '📏', '✏️', '🪚', '⛏️', '🎚️', '🔋', '⚗️', '🔗', '🪝', '🧰'];/" frontend/app.js
commit "feat(animation): replace emojis with engineering tool icons"

# =====================
# COMMIT 35: Update animation comment
# =====================
sed -i 's/\/\/ Floating Emoticons Animation/\/\/ Floating Engineering Tools Animation/' frontend/app.js
commit "docs(js): update animation comment for engineering theme"

# =====================
# COMMIT 36: Update emoji glow filter
# =====================
sed -i 's/.floating-emoji { filter: drop-shadow(0 0 5px rgba(255, 255, 255, 0.3)); }/.floating-emoji { filter: drop-shadow(0 0 8px rgba(192, 192, 192, 0.4)); }/' frontend/styles.css
commit "style(animation): update floating icon glow to metallic silver"

# =====================
# COMMIT 37: Update page title
# =====================
sed -i 's/<title>Mini Collectibles - Base Chain NFT Platform<\/title>/<title>Mini Collectibles - Base Chain NFT Platform | Metallic Engineering Theme<\/title>/' frontend/index.html
commit "docs(html): update page title for metallic theme"

# =====================
# COMMIT 38: Update header emoji
# =====================
sed -i 's/🎨 Mini Collectibles/⚙️ Mini Collectibles/' frontend/index.html
commit "style(html): update header icon to gear emoji"

# =====================
# COMMIT 39: Add utility classes
# =====================
cat >> frontend/styles.css << 'EOF'

/* Metallic Utility Classes */
.metallic-text { background: linear-gradient(90deg, var(--metallic-silver), var(--metallic-platinum), var(--metallic-chrome)); -webkit-background-clip: text; -webkit-text-fill-color: transparent; background-clip: text; }
.metallic-border { border: 2px solid var(--metallic-chrome); }
.metallic-shadow { box-shadow: 0 4px 12px rgba(0,0,0,0.4), inset 0 1px 0 rgba(255,255,255,0.1); }
.chrome-btn { background: linear-gradient(180deg, var(--metallic-chrome) 0%, var(--metallic-steel) 100%); }
EOF
commit "feat(utilities): add metallic utility CSS classes"

# =====================
# COMMIT 40: Update close modal button
# =====================
sed -i 's/#close-modal { background: linear-gradient(90deg, #616161, #424242);/#close-modal { background: linear-gradient(180deg, var(--metallic-chrome) 0%, var(--metallic-steel) 100%);/' frontend/styles.css
commit "style(button): apply metallic gradient to close modal button"

# =====================
# COMMIT 41: Add engineering SVG background
# =====================
cat >> frontend/styles.css << 'EOF'

/* Engineering Tool Background Pattern */
.engineering-bg::before {
    content: '';
    position: fixed;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    pointer-events: none;
    z-index: 0;
    background-image: 
        url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 100 100'%3E%3Cg opacity='0.05'%3E%3Ccircle cx='50' cy='50' r='30' fill='none' stroke='%23C0C0C0' stroke-width='3'/%3E%3Crect x='45' y='10' width='10' height='15' fill='%23C0C0C0'/%3E%3Crect x='45' y='75' width='10' height='15' fill='%23C0C0C0'/%3E%3C/g%3E%3C/svg%3E");
    background-size: 150px 150px;
    animation: floatTools 60s linear infinite;
}
EOF
commit "feat(background): add engineering gear SVG background pattern"

# =====================
# COMMIT 42: Add float animation for tools
# =====================
cat >> frontend/styles.css << 'EOF'

/* Float Tools Animation */
@keyframes floatTools {
    0% { background-position: 0 0; }
    100% { background-position: 150px -200px; }
}
EOF
commit "feat(animation): add floating tools background animation"

# =====================
# COMMIT 43: Update body::before animation
# =====================
sed -i 's/animation: floatFlowers 60s linear infinite;/animation: floatTools 80s linear infinite;/' frontend/styles.css
commit "style(animation): update background animation to floatTools"

# =====================
# COMMIT 44: Update README theme description
# =====================
sed -i 's/Pink Hibiscus Theme/Metallic Engineering Theme/' README.md
sed -i 's/pink gradient/metallic gradient/' README.md
commit "docs(readme): update theme description to Metallic Engineering"

# =====================
# COMMIT 45: Update README badge
# =====================
sed -i 's/Theme-Pink%20Hibiscus-ff69b4/Theme-Metallic%20Engineering-C0C0C0/' README.md
commit "docs(readme): update theme badge to metallic silver"

echo "✅ Successfully created 45 commits for Metallic Engineering Theme!"
git log --oneline -50
