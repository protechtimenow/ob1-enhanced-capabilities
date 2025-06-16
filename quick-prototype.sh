#!/bin/bash
# 🚀 OB-1 Enhanced AI - Super Quick Prototyping Setup
# Run this for instant development environment!

set -e

echo "🚀 OB-1 ENHANCED AI - QUICK PROTOTYPING SETUP"
echo "============================================="

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

print_step() {
    echo -e "${BLUE}🔧 $1${NC}"
}

print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️ $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

# Step 1: Environment Check
print_step "Checking environment..."

if command -v python3 &> /dev/null; then
    print_success "Python3 found: $(python3 --version)"
else
    print_error "Python3 not found!"
    exit 1
fi

if command -v pip &> /dev/null; then
    print_success "Pip found: $(pip --version)"
else
    print_error "Pip not found!"
    exit 1
fi

# Step 2: Quick Dependencies Install
print_step "Installing minimal dependencies for prototyping..."

# Create minimal requirements for fast startup
cat > /tmp/quick-requirements.txt << EOF
flask==2.3.2
requests==2.31.0
python-dotenv==1.0.0
flask-cors==4.0.0
gunicorn==21.2.0
EOF

pip install -q -r /tmp/quick-requirements.txt
print_success "Dependencies installed quickly!"

# Step 3: Environment Setup
print_step "Setting up environment..."

if [ ! -f .env ]; then
    cat > .env << EOF
# OB-1 Enhanced AI - Development Environment
FLASK_ENV=development
FLASK_DEBUG=true
PORT=5000
GITHUB_TOKEN=your_token_here
OPENAI_API_KEY=your_key_here

# Development flags
FAST_MODE=true
DEBUG_LOGGING=true
AUTO_RELOAD=true
EOF
    print_success "Environment file created!"
else
    print_warning "Environment file already exists"
fi

# Step 4: Quick Port Check
print_step "Checking available ports..."

check_port() {
    local port=$1
    if lsof -i:$port >/dev/null 2>&1; then
        return 1
    else
        return 0
    fi
}

PORT=5000
while ! check_port $PORT && [ $PORT -lt 5010 ]; do
    PORT=$((PORT + 1))
done

print_success "Using port: $PORT"

# Step 5: Launch Options
echo ""
echo "🎯 PROTOTYPING ENVIRONMENT READY!"
echo "================================="
echo ""

echo "📱 OPTION 1: INSTANT DEV SERVER (Recommended)"
echo "   Command: python3 fast-dev-server.py"
echo "   Speed: 🟢 Instant (15 seconds)"
echo "   Features: Hot reload, debug mode, fast iteration"
echo ""

echo "🌐 OPTION 2: CODESPACE PORTS (Team Access)"
echo "   1. Run: python3 fast-dev-server.py"
echo "   2. Go to 'Ports' tab in Codespace"
echo "   3. Make port $PORT public"
echo "   Speed: 🟢 Instant (30 seconds)"
echo ""

echo "🔗 OPTION 3: NGROK TUNNEL (Public Access)"
echo "   1. Install: curl -s https://ngrok-agent.s3.amazonaws.com/ngrok.asc | sudo tee /etc/apt/trusted.gpg.d/ngrok.asc >/dev/null"
echo "   2. Add repo: echo 'deb https://ngrok-agent.s3.amazonaws.com buster main' | sudo tee /etc/apt/sources.list.d/ngrok.list"
echo "   3. Install: sudo apt update && sudo apt install ngrok"
echo "   4. Run server: python3 fast-dev-server.py &"
echo "   5. Tunnel: ngrok http $PORT"
echo "   Speed: 🟡 Fast (2 minutes)"
echo ""

echo "⚡ OPTION 4: VERCEL INSTANT DEPLOY"
echo "   1. Install: npm i -g vercel"
echo "   2. Deploy: vercel --prod"
echo "   Speed: 🟡 Fast (3 minutes)"
echo ""

# Step 6: Quick Test Script
cat > test-prototype.py << EOF
#!/usr/bin/env python3
"""Quick test script for OB-1 prototyping"""

import requests
import json
import time

def test_endpoints():
    base_url = "http://localhost:$PORT"
    
    tests = [
        {"name": "Health Check", "endpoint": "/health"},
        {"name": "Home Page", "endpoint": "/"},
    ]
    
    print("🧪 TESTING PROTOTYPE ENDPOINTS")
    print("=" * 30)
    
    for test in tests:
        try:
            response = requests.get(f"{base_url}{test['endpoint']}", timeout=5)
            if response.status_code == 200:
                print(f"✅ {test['name']}: OK")
            else:
                print(f"❌ {test['name']}: Failed ({response.status_code})")
        except Exception as e:
            print(f"❌ {test['name']}: Error - {str(e)}")
    
    # Test AI Chat
    try:
        response = requests.post(f"{base_url}/ai-chat", 
                               json={"message": "Hello OB-1!"}, 
                               timeout=5)
        if response.status_code == 200:
            data = response.json()
            print(f"✅ AI Chat: {data.get('response', 'OK')[:50]}...")
        else:
            print(f"❌ AI Chat: Failed ({response.status_code})")
    except Exception as e:
        print(f"❌ AI Chat: Error - {str(e)}")

if __name__ == "__main__":
    print("Waiting for server to start...")
    time.sleep(2)
    test_endpoints()
EOF

chmod +x test-prototype.py
print_success "Test script created!"

# Step 7: Start Commands
cat > start-fast-dev.sh << EOF
#!/bin/bash
echo "🚀 Starting OB-1 Fast Development Server..."
export FLASK_ENV=development
export FLASK_DEBUG=1
python3 fast-dev-server.py
EOF

chmod +x start-fast-dev.sh
print_success "Start script created!"

# Final Instructions
echo ""
echo "🎉 SETUP COMPLETE - CHOOSE YOUR SPEED:"
echo "====================================="
echo ""
echo "🟢 INSTANT START (Recommended):"
echo "   ./start-fast-dev.sh"
echo ""
echo "🟢 OR MANUAL:"
echo "   python3 fast-dev-server.py"
echo ""
echo "🧪 TEST YOUR PROTOTYPE:"
echo "   python3 test-prototype.py"
echo ""
echo "📱 ACCESS VIA CODESPACE:"
echo "   1. Start server above"
echo "   2. Go to 'Ports' tab"
echo "   3. Click globe icon on port $PORT"
echo ""
echo "⚡ Ready for lightning-fast prototyping!"
print_success "All set! Choose your option above ⬆️"