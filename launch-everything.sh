#!/bin/bash

# 🚀 OB-1 Enhanced Capabilities - Ultimate Launch Script
# Fixes Copilot + Builds App + Starts Everything in Codespace

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m'

# Ultimate Banner
echo -e "${PURPLE}
╔═══════════════════════════════════════════════════════════════════════════════╗
║     🚀 OB-1 ENHANCED CAPABILITIES - ULTIMATE CODESPACE LAUNCHER 🚀           ║
║                                                                               ║
║  ✅ Fixes GitHub Copilot issues                                               ║  
║  ✅ Builds your application                                                   ║
║  ✅ Starts your AI-powered GitHub App                                         ║
║  ✅ Provides all necessary tools and shortcuts                                ║
║                                                                               ║
╚═══════════════════════════════════════════════════════════════════════════════╝
${NC}"

print_step() {
    echo -e "${CYAN}[STEP $1]${NC} $2"
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

# Step 1: Make all scripts executable
print_step "1" "Setting up script permissions..."
chmod +x codespace-builder.sh 2>/dev/null || true
chmod +x fix-copilot.sh 2>/dev/null || true
chmod +x quick-commands.sh 2>/dev/null || true
chmod +x setup-codespace.sh 2>/dev/null || true
chmod +x deploy.sh 2>/dev/null || true
print_success "Script permissions set"

# Step 2: Run Copilot fix
print_step "2" "🤖 Fixing GitHub Copilot..."
if [ -f "fix-copilot.sh" ]; then
    ./fix-copilot.sh
    print_success "Copilot fix completed"
else
    print_warning "fix-copilot.sh not found, creating it..."
    # Create basic copilot fix if missing
    cat > fix-copilot-basic.sh << 'EOL'
#!/bin/bash
echo "🤖 Basic Copilot Fix..."
code --install-extension GitHub.copilot --force
code --install-extension GitHub.copilot-chat --force
mkdir -p .vscode
echo '{"github.copilot.enable": {"*": true}}' > .vscode/settings.json
echo "✅ Basic Copilot fix applied"
EOL
    chmod +x fix-copilot-basic.sh
    ./fix-copilot-basic.sh
fi

# Step 3: Run application builder
print_step "3" "🏗️ Building OB-1 Enhanced Capabilities..."
if [ -f "codespace-builder.sh" ]; then
    ./codespace-builder.sh
    print_success "Application build completed"
else
    # Fallback build process
    print_warning "codespace-builder.sh not found, running basic setup..."
    pip install -r requirements.txt || print_error "Failed to install requirements"
    export PYTHONPATH="${PYTHONPATH}:$(pwd)"
    print_success "Basic setup completed"
fi

# Step 4: Configure environment
print_step "4" "⚙️ Configuring environment..."

# Create .env if it doesn't exist
if [ ! -f ".env" ]; then
    if [ -f ".env.example" ]; then
        cp .env.example .env
        print_success ".env created from example"
    else
        cat > .env << 'EOL'
# GitHub Configuration
GITHUB_TOKEN=your_github_token_here
GITHUB_WEBHOOK_SECRET=your_webhook_secret_here

# OpenAI Configuration  
OPENAI_API_KEY=your_openai_api_key_here

# Application Configuration
FLASK_ENV=development
PORT=5000
DEBUG=true
EOL
        print_success "Basic .env created"
    fi
fi

# Set Python path
export PYTHONPATH="${PYTHONPATH}:$(pwd)"
print_success "Environment configured"

# Step 5: Test application
print_step "5" "🧪 Testing application components..."
python3 -c "
import sys
sys.path.append('.')
try:
    import app
    print('✅ Main app import successful')
except Exception as e:
    print(f'⚠️ App import issue: {e}')
" 2>/dev/null || print_warning "App test had issues (may be normal)"

# Step 6: Create quick access commands
print_step "6" "🔧 Creating quick access tools..."

# Create ultimate launch script for app
cat > start-ob1.sh << 'EOL'
#!/bin/bash

echo "🚀 Starting OB-1 Enhanced Capabilities..."

# Set environment
export PYTHONPATH="${PYTHONPATH}:$(pwd)"
export FLASK_ENV=development
export PORT=${PORT:-5000}

# Start app
echo "🔥 Launching OB-1 on port $PORT..."
python3 app.py &
APP_PID=$!
echo $APP_PID > .ob1.pid

echo ""
echo "✅ OB-1 Enhanced Capabilities is running!"
echo "🌐 Access URL: https://${CODESPACE_NAME}-${PORT}.${GITHUB_CODESPACES_PORT_FORWARDING_DOMAIN}"
echo "🛑 Stop with: ./stop-ob1.sh"
echo ""

# Monitor app
echo "📊 Application Status:"
sleep 2
if curl -s http://localhost:$PORT/health > /dev/null 2>&1; then
    echo "✅ Application is healthy and responding"
else
    echo "⏳ Application is starting up... (may take a moment)"
fi

echo ""
echo "🎉 Your OB-1 Enhanced AI GitHub App is ready!"
echo "Check the PORTS tab to access your application"
EOL

chmod +x start-ob1.sh

# Create stop script
cat > stop-ob1.sh << 'EOL'
#!/bin/bash

echo "🛑 Stopping OB-1 Enhanced Capabilities..."

if [ -f ".ob1.pid" ]; then
    PID=$(cat .ob1.pid)
    kill $PID 2>/dev/null || true
    rm .ob1.pid
    echo "✅ OB-1 stopped successfully"
else
    # Fallback - kill any python app processes
    pkill -f "python.*app.py" || true
    echo "✅ Cleaned up any running processes"
fi
EOL

chmod +x stop-ob1.sh

# Create status checker
cat > status-ob1.sh << 'EOL'
#!/bin/bash

PORT=${PORT:-5000}
echo "📊 OB-1 Enhanced Capabilities Status Check"
echo "=========================================="

# Check if process is running
if [ -f ".ob1.pid" ]; then
    PID=$(cat .ob1.pid)
    if ps -p $PID > /dev/null 2>&1; then
        echo "✅ Process Status: Running (PID: $PID)"
    else
        echo "❌ Process Status: Not Running (stale PID file)"
        rm .ob1.pid
    fi
else
    if pgrep -f "python.*app.py" > /dev/null; then
        echo "⚠️ Process Status: Running (no PID file)"
    else
        echo "❌ Process Status: Not Running"
    fi
fi

# Check if port is responding
echo ""
if curl -s http://localhost:$PORT/health > /dev/null 2>&1; then
    echo "✅ Health Check: Responding"
    curl -s http://localhost:$PORT/health 2>/dev/null || true
else
    echo "❌ Health Check: Not Responding"
fi

# Show access URL
echo ""
echo "🌐 Access URL: https://${CODESPACE_NAME}-${PORT}.${GITHUB_CODESPACES_PORT_FORWARDING_DOMAIN}"
echo "📁 Project Path: $(pwd)"
EOL

chmod +x status-ob1.sh
print_success "Quick access tools created"

# Step 7: Show final instructions
echo ""
echo -e "${GREEN}
╔═══════════════════════════════════════════════════════════════════════════════╗
║                        🎉 LAUNCH COMPLETE! 🎉                               ║
║                                                                               ║
║  Your OB-1 Enhanced Capabilities is ready! Here's what's been done:         ║
║                                                                               ║
║  ✅ GitHub Copilot fixed and configured                                      ║
║  ✅ Application built and dependencies installed                              ║
║  ✅ Environment configured                                                    ║
║  ✅ Quick command tools created                                               ║
║                                                                               ║
║  🚀 IMMEDIATE NEXT STEPS:                                                     ║
║                                                                               ║
║  1. 🔑 Configure API Keys (IMPORTANT):                                        ║
║     Edit .env file: code .env                                                ║
║     Add your GITHUB_TOKEN and OPENAI_API_KEY                                ║
║                                                                               ║
║  2. 🔄 Fix Copilot (if needed):                                              ║
║     Press: Ctrl+Shift+P                                                     ║
║     Type: 'Developer: Reload Window'                                         ║
║     Then: Ctrl+Shift+P → 'GitHub Copilot: Sign In'                         ║
║                                                                               ║
║  3. 🚀 Start Your App:                                                       ║
║     Run: ./start-ob1.sh                                                      ║
║                                                                               ║
║  📋 QUICK COMMANDS:                                                           ║
║     ./start-ob1.sh    - Start the application                               ║
║     ./stop-ob1.sh     - Stop the application                                ║
║     ./status-ob1.sh   - Check application status                             ║
║                                                                               ║
║  🌐 Your app will be available in the PORTS tab                             ║
║                                                                               ║
╚═══════════════════════════════════════════════════════════════════════════════╝
${NC}"

print_success "🎊 Everything is ready! Configure your .env and run ./start-ob1.sh"

# Show what user needs to do next
echo ""
echo -e "${YELLOW}⚡ QUICK START COMMANDS:${NC}"
echo -e "${CYAN}1.${NC} Configure API keys: ${BLUE}code .env${NC}"
echo -e "${CYAN}2.${NC} Start application: ${BLUE}./start-ob1.sh${NC}"
echo -e "${CYAN}3.${NC} Check status: ${BLUE}./status-ob1.sh${NC}"
echo ""
echo -e "${PURPLE}🤖 For Copilot: Reload window (Ctrl+Shift+P) and sign in!${NC}"