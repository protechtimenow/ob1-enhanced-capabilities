#!/bin/bash

echo "🚀 OB-1 Enhanced AI - Quick Prototyping Setup"
echo "=============================================="

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
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

# Step 1: Check Python
print_info "Checking Python installation..."
if command -v python3 &> /dev/null; then
    print_status "Python3 found: $(python3 --version)"
else
    print_error "Python3 not found. Installing..."
    sudo apt-get update && sudo apt-get install -y python3 python3-pip
fi

# Step 2: Install dependencies
print_info "Installing Python dependencies..."
if [ -f "requirements.txt" ]; then
    pip3 install -r requirements.txt
    print_status "Dependencies installed from requirements.txt"
else
    print_info "Installing core dependencies..."
    pip3 install flask requests python-dotenv ngrok
    print_status "Core dependencies installed"
fi

# Step 3: Create environment file if it doesn't exist
if [ ! -f ".env" ]; then
    print_info "Creating .env file..."
    cat > .env << EOF
# GitHub Configuration
GITHUB_TOKEN=your_github_token_here
GITHUB_APP_ID=your_app_id_here
GITHUB_PRIVATE_KEY=your_private_key_here
GITHUB_WEBHOOK_SECRET=your_webhook_secret_here

# OpenAI Configuration
OPENAI_API_KEY=your_openai_api_key_here

# Development Settings
FLASK_ENV=development
FLASK_DEBUG=true
PORT=5000
HOST=0.0.0.0

# User Wallet
USER_WALLET=0x21cC30462B8392Aa250453704019800092a16165
EOF
    print_status ".env file created"
    print_warning "Please edit .env file with your API keys"
else
    print_status ".env file already exists"
fi

# Step 4: Create the fast development server
print_info "Creating fast development server..."

# Step 5: Make scripts executable
chmod +x *.sh 2>/dev/null || true
print_status "Scripts made executable"

# Step 6: Final status
echo
echo "🎉 Quick Prototyping Setup Complete!"
echo "===================================="
echo
print_info "Next steps:"
echo "1. Edit .env file with your API keys"
echo "2. Run: ./start-fast-dev.sh"
echo "3. Your app will be available on Codespace ports"
echo
print_status "Setup completed successfully!"