#!/bin/bash

# 🤖 GitHub Copilot Fix Script for Codespace
# Resolves common Copilot issues in GitHub Codespaces

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m'

# Banner
echo -e "${BLUE}
╔═══════════════════════════════════════════════════════════════════════════════╗
║                    🤖 GitHub Copilot Fix for Codespace                       ║
╚═══════════════════════════════════════════════════════════════════════════════╝
${NC}"

print_step() {
    echo -e "${CYAN}[STEP]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

# Step 1: Check GitHub authentication
print_step "Checking GitHub authentication..."
if command -v gh &> /dev/null; then
    if gh auth status | grep -q "Logged in"; then
        print_success "GitHub CLI authentication confirmed"
    else
        print_error "GitHub CLI not authenticated"
        echo "Run: gh auth login"
        exit 1
    fi
else
    print_warning "GitHub CLI not installed"
fi

# Step 2: Install VS Code extensions via command line
print_step "Installing GitHub Copilot extensions..."

# Extension IDs
COPILOT_EXTENSION="GitHub.copilot"
COPILOT_CHAT_EXTENSION="GitHub.copilot-chat"

# Install extensions
print_step "Installing GitHub Copilot extension..."
if command -v code &> /dev/null; then
    code --install-extension $COPILOT_EXTENSION --force
    if [ $? -eq 0 ]; then
        print_success "GitHub Copilot extension installed"
    else
        print_warning "Failed to install Copilot extension via CLI"
    fi
    
    code --install-extension $COPILOT_CHAT_EXTENSION --force
    if [ $? -eq 0 ]; then
        print_success "GitHub Copilot Chat extension installed"
    else
        print_warning "Failed to install Copilot Chat extension via CLI"
    fi
else
    print_warning "VS Code CLI not available"
fi

# Step 3: Create VS Code settings for Copilot
print_step "Configuring VS Code settings for Copilot..."
mkdir -p .vscode

# Enhanced VS Code settings
cat > .vscode/settings.json << 'EOF'
{
    "python.defaultInterpreterPath": "/usr/bin/python3",
    "python.terminal.activateEnvironment": true,
    "github.copilot.enable": {
        "*": true,
        "plaintext": true,
        "markdown": true,
        "scminput": false,
        "python": true,
        "javascript": true,
        "typescript": true,
        "go": true,
        "rust": true
    },
    "github.copilot.advanced": {
        "debug.overrideEngine": "codex",
        "debug.testOverrideProxyUrl": "",
        "debug.overrideProxyUrl": ""
    },
    "github.copilot-chat.enable": {
        "*": true
    },
    "terminal.integrated.env.linux": {
        "PYTHONPATH": "${workspaceFolder}"
    },
    "files.autoSave": "afterDelay",
    "editor.inlineSuggest.enabled": true,
    "editor.suggest.preview": true
}
EOF

# Enhanced extensions recommendations
cat > .vscode/extensions.json << 'EOF'
{
    "recommendations": [
        "github.copilot",
        "github.copilot-chat",
        "ms-python.python",
        "ms-python.pylint",
        "ms-python.flake8",
        "ms-python.black-formatter",
        "ms-vscode.vscode-json",
        "redhat.vscode-yaml"
    ]
}
EOF

print_success "VS Code configuration updated"

# Step 4: Create Copilot test script
print_step "Creating Copilot test script..."
cat > test-copilot.py << 'EOF'
#!/usr/bin/env python3

"""
Copilot Test Script
Type the comment below and press TAB to test Copilot
"""

# Function to calculate the fibonacci sequence up to n terms

# Class to represent a blockchain transaction

# Function to validate an Ethereum address

# Create a REST API endpoint using Flask

# Function to parse JSON data from an API response

print("🤖 Copilot Test Script Ready!")
print("Open this file in VS Code and try typing comments followed by TAB")
print("If Copilot is working, it should suggest code completions")
EOF

chmod +x test-copilot.py
print_success "Copilot test script created"

# Step 5: Create manual extension installer
print_step "Creating manual extension installer..."
cat > install-copilot-extensions.py << 'EOF'
#!/usr/bin/env python3

import subprocess
import sys
import time

def run_command(cmd):
    """Run a shell command and return success status"""
    try:
        result = subprocess.run(cmd, shell=True, capture_output=True, text=True)
        return result.returncode == 0, result.stdout, result.stderr
    except Exception as e:
        return False, "", str(e)

def install_extension(extension_id):
    """Install a VS Code extension"""
    print(f"📦 Installing {extension_id}...")
    cmd = f"code --install-extension {extension_id} --force"
    success, stdout, stderr = run_command(cmd)
    
    if success:
        print(f"✅ Successfully installed {extension_id}")
        return True
    else:
        print(f"❌ Failed to install {extension_id}")
        print(f"Error: {stderr}")
        return False

def main():
    print("🤖 Manual Copilot Extension Installer")
    print("=" * 50)
    
    extensions = [
        "GitHub.copilot",
        "GitHub.copilot-chat"
    ]
    
    success_count = 0
    
    for ext in extensions:
        if install_extension(ext):
            success_count += 1
        time.sleep(2)  # Wait between installations
    
    print(f"\n📊 Results: {success_count}/{len(extensions)} extensions installed")
    
    if success_count == len(extensions):
        print("🎉 All extensions installed successfully!")
        print("\n🔄 Please reload VS Code window:")
        print("   Ctrl+Shift+P → 'Developer: Reload Window'")
        print("\n🔑 Then sign in to Copilot:")
        print("   Ctrl+Shift+P → 'GitHub Copilot: Sign In'")
    else:
        print("⚠️  Some extensions failed to install")
        print("Try installing manually from VS Code Extensions panel")

if __name__ == "__main__":
    main()
EOF

chmod +x install-copilot-extensions.py
print_success "Manual installer created"

# Step 6: Create troubleshooting script
print_step "Creating troubleshooting script..."
cat > troubleshoot-copilot.sh << 'EOF'
#!/bin/bash

echo "🔧 GitHub Copilot Troubleshooting Script"
echo "========================================"

echo ""
echo "1. 📋 Checking extension installation..."
code --list-extensions | grep -i copilot
if [ $? -eq 0 ]; then
    echo "✅ Copilot extensions found"
else
    echo "❌ Copilot extensions not found"
    echo "Run: ./install-copilot-extensions.py"
fi

echo ""
echo "2. 🔐 Checking GitHub authentication..."
gh auth status 2>/dev/null
if [ $? -eq 0 ]; then
    echo "✅ GitHub authentication active"
else
    echo "❌ GitHub authentication issue"
    echo "Run: gh auth login"
fi

echo ""
echo "3. 📁 Checking VS Code configuration..."
if [ -f ".vscode/settings.json" ]; then
    echo "✅ VS Code settings found"
else
    echo "❌ VS Code settings missing"
    echo "Run: ./fix-copilot.sh"
fi

echo ""
echo "4. 🔄 Recommended fixes:"
echo "   - Reload VS Code window: Ctrl+Shift+P → 'Developer: Reload Window'"
echo "   - Sign in to Copilot: Ctrl+Shift+P → 'GitHub Copilot: Sign In'"
echo "   - Check extension status in Extensions panel"

echo ""
echo "5. 🧪 Test Copilot:"
echo "   - Open test-copilot.py"
echo "   - Type a comment and press TAB"
echo "   - Look for code suggestions"

echo ""
echo "If issues persist:"
echo "   - Restart Codespace completely"
echo "   - Check GitHub Copilot subscription status"
echo "   - Try incognito/private browsing mode"
EOF

chmod +x troubleshoot-copilot.sh
print_success "Troubleshooting script created"

# Step 7: Actually run the extension installation
print_step "Running extension installation..."
python3 install-copilot-extensions.py

# Step 8: Final instructions
echo ""
echo -e "${GREEN}
╔═══════════════════════════════════════════════════════════════════════════════╗
║                         🎉 COPILOT FIX COMPLETE! 🎉                         ║
║                                                                               ║
║  Next Steps to Complete Setup:                                               ║
║                                                                               ║
║  1. 🔄 RELOAD VS CODE WINDOW:                                                ║
║     Press: Ctrl+Shift+P                                                     ║
║     Type: 'Developer: Reload Window'                                         ║
║     Press: Enter                                                             ║
║                                                                               ║
║  2. 🔑 SIGN IN TO COPILOT:                                                   ║
║     Press: Ctrl+Shift+P                                                     ║
║     Type: 'GitHub Copilot: Sign In'                                         ║
║     Follow the authentication flow                                           ║
║                                                                               ║
║  3. 🧪 TEST COPILOT:                                                         ║
║     Open: test-copilot.py                                                    ║
║     Type a comment + press TAB                                               ║
║                                                                               ║
║  4. 🚀 START YOUR APP:                                                       ║
║     Run: ./quick-commands.sh start                                           ║
║                                                                               ║
║  📞 If still not working:                                                    ║
║     Run: ./troubleshoot-copilot.sh                                           ║
║                                                                               ║
╚═══════════════════════════════════════════════════════════════════════════════╝
${NC}"

print_success "🤖 Copilot fix script completed!"
print_warning "Remember to RELOAD VS Code window and SIGN IN to Copilot!"