#!/bin/bash

echo "🤖 Fixing GitHub Copilot in VS Code Codespace"
echo "============================================"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

print_status() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

print_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

print_header() {
    echo -e "${BLUE}🔧 $1${NC}"
}

# Step 1: Check if we're in a codespace
print_header "Checking Environment"
if [ -n "$CODESPACE_NAME" ]; then
    print_status "Running in GitHub Codespace: $CODESPACE_NAME"
else
    print_warning "Not in a GitHub Codespace - some features may not work"
fi

# Step 2: Check VS Code installation
print_header "Checking VS Code"
if command -v code &> /dev/null; then
    print_status "VS Code CLI found"
else
    print_warning "VS Code CLI not found - installing..."
    curl -fsSL https://code.visualstudio.com/sha/download?build=stable&os=cli-alpine-x64 | tar -xz -C /tmp
    sudo mv /tmp/code /usr/local/bin/
fi

# Step 3: Install Copilot extensions
print_header "Installing GitHub Copilot Extensions"

# Install main Copilot extension
print_info "Installing GitHub Copilot..."
code --install-extension GitHub.copilot --force
if [ $? -eq 0 ]; then
    print_status "GitHub Copilot extension installed"
else
    print_error "Failed to install GitHub Copilot extension"
fi

# Install Copilot Chat extension
print_info "Installing GitHub Copilot Chat..."
code --install-extension GitHub.copilot-chat --force
if [ $? -eq 0 ]; then
    print_status "GitHub Copilot Chat extension installed"
else
    print_error "Failed to install GitHub Copilot Chat extension"
fi

# Step 4: Check GitHub authentication
print_header "Checking GitHub Authentication"
if command -v gh &> /dev/null; then
    gh_status=$(gh auth status 2>&1)
    if echo "$gh_status" | grep -q "Logged in"; then
        print_status "GitHub CLI authenticated"
        echo "$gh_status"
    else
        print_warning "GitHub CLI not authenticated"
        print_info "Run: gh auth login"
    fi
else
    print_warning "GitHub CLI not found"
fi

# Step 5: Create VS Code settings for Copilot
print_header "Configuring VS Code Settings"
VSCODE_SETTINGS_DIR="$HOME/.vscode-server/data/Machine"
mkdir -p "$VSCODE_SETTINGS_DIR"

# Create settings.json if it doesn't exist
SETTINGS_FILE="$VSCODE_SETTINGS_DIR/settings.json"
if [ ! -f "$SETTINGS_FILE" ]; then
    print_info "Creating VS Code settings.json..."
    cat > "$SETTINGS_FILE" << 'EOF'
{
    "github.copilot.enable": {
        "*": true,
        "yaml": true,
        "plaintext": true,
        "markdown": true,
        "javascript": true,
        "typescript": true,
        "python": true,
        "json": true,
        "jsonc": true,
        "html": true,
        "css": true,
        "scss": true,
        "less": true,
        "vue": true,
        "jsx": true,
        "tsx": true,
        "php": true,
        "go": true,
        "rust": true,
        "java": true,
        "c": true,
        "cpp": true,
        "csharp": true,
        "ruby": true,
        "shellscript": true,
        "sql": true,
        "dockerfile": true,
        "solidity": true
    },
    "github.copilot.advanced": {
        "debug.overrideEngine": "copilot-codex",
        "debug.testOverrideProxyUrl": "",
        "debug.overrideProxyUrl": "",
        "debug.filterLogCategories": []
    },
    "github.copilot.chat.enabled": true,
    "github.copilot.chat.welcomeMessage": "enabled",
    "workbench.editorAssociations": {
        "*.md": "vscode.markdown.preview.editor"
    }
}
EOF
    print_status "VS Code settings.json created"
else
    print_info "VS Code settings.json already exists"
fi

# Step 6: List installed extensions
print_header "Checking Installed Extensions"
print_info "Currently installed VS Code extensions:"
code --list-extensions | grep -E "(copilot|github)" || print_warning "No Copilot extensions found"

# Step 7: Create a test file for Copilot
print_header "Creating Test File"
TEST_FILE="copilot-test.py"
cat > "$TEST_FILE" << 'EOF'
# Test file for GitHub Copilot
# Type the comment below and press TAB to test Copilot

# Function to calculate fibonacci numbers

# Function to reverse a string

# Function to check if a number is prime

# Smart contract function to transfer tokens
EOF

print_status "Test file created: $TEST_FILE"

# Step 8: Instructions for manual steps
print_header "Manual Steps Required"
echo
print_info "Complete these steps manually:"
echo "1. Reload VS Code window:"
echo "   - Press Ctrl+Shift+P"
echo "   - Type 'Developer: Reload Window'"
echo "   - Press Enter"
echo
echo "2. Sign in to GitHub Copilot:"
echo "   - Press Ctrl+Shift+P"
echo "   - Type 'GitHub Copilot: Sign In'"
echo "   - Follow the authentication flow"
echo
echo "3. Test Copilot:"
echo "   - Open the file: $TEST_FILE"
echo "   - Place cursor after any comment"
echo "   - Press Tab to see suggestions"
echo
echo "4. Test Copilot Chat:"
echo "   - Press Ctrl+Shift+P"
echo "   - Type 'GitHub Copilot: Open Chat'"
echo "   - Ask: 'How do I create a smart contract?'"
echo

# Step 9: Create troubleshooting script
print_header "Creating Troubleshooting Tools"
cat > copilot-troubleshoot.sh << 'EOF'
#!/bin/bash

echo "🔍 GitHub Copilot Troubleshooting"
echo "================================"

# Check extensions
echo "📦 Installed Extensions:"
code --list-extensions | grep -i copilot

# Check settings
echo
echo "⚙️  VS Code Settings:"
if [ -f "$HOME/.vscode-server/data/Machine/settings.json" ]; then
    echo "✅ Settings file exists"
    grep -A 5 -B 5 "copilot" "$HOME/.vscode-server/data/Machine/settings.json" || echo "❌ No copilot settings found"
else
    echo "❌ Settings file not found"
fi

# Check GitHub auth
echo
echo "🔐 GitHub Authentication:"
if command -v gh &> /dev/null; then
    gh auth status 2>&1 | head -5
else
    echo "❌ GitHub CLI not found"
fi

# Check VS Code processes
echo
echo "🔄 VS Code Processes:"
ps aux | grep -E "(code|copilot)" | head -5

echo
echo "💡 Quick Fixes:"
echo "- Restart VS Code: Ctrl+Shift+P > Developer: Reload Window"
echo "- Sign in again: Ctrl+Shift+P > GitHub Copilot: Sign In"
echo "- Check subscription: https://github.com/settings/copilot"
echo "- Try incognito mode if browser issues"
EOF

chmod +x copilot-troubleshoot.sh
print_status "Troubleshooting script created: copilot-troubleshoot.sh"

# Final status
echo
echo "🎉 GitHub Copilot Fix Complete!"
echo "==============================="
echo
print_status "✅ Extensions installed"
print_status "✅ Settings configured"
print_status "✅ Test file created"
print_status "✅ Troubleshooting tools ready"
echo
print_warning "⚠️  Manual steps required (see above)"
print_info "💡 Run ./copilot-troubleshoot.sh if issues persist"
echo
print_info "🚀 Now run: ./start-fast-dev.sh (for your main application)"