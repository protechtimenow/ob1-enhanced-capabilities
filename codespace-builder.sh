#!/bin/bash

# 🚀 OB-1 Enhanced Capabilities - Codespace Builder
# Automated build and execution script for GitHub Codespaces

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Banner
echo -e "${PURPLE}
╔═══════════════════════════════════════════════════════════════════════════════╗
║                    🚀 OB-1 Enhanced Capabilities Builder                      ║
║                           Codespace Edition                                   ║
╚═══════════════════════════════════════════════════════════════════════════════╝
${NC}"

# Function to print colored output
print_step() {
    echo -e "${CYAN}[INFO]${NC} $1"
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

# Step 1: Environment Setup
print_step "Setting up environment..."

# Check if .env exists
if [ ! -f ".env" ]; then
    print_warning ".env file not found. Creating from example..."
    if [ -f ".env.example" ]; then
        cp .env.example .env
        print_success "Created .env file from example"
    else
        print_error ".env.example not found. Creating basic .env file..."
        cat > .env << EOL
# GitHub Configuration
GITHUB_TOKEN=your_github_token_here
GITHUB_WEBHOOK_SECRET=your_webhook_secret_here

# OpenAI Configuration
OPENAI_API_KEY=your_openai_api_key_here

# Application Configuration
FLASK_ENV=development
PORT=5000
DEBUG=true

# Database Configuration (optional)
DATABASE_URL=sqlite:///./app.db
EOL
        print_success "Created basic .env file"
    fi
fi

# Step 2: Install Dependencies
print_step "Installing Python dependencies..."
if [ -f "requirements.txt" ]; then
    pip install -r requirements.txt
    print_success "Dependencies installed"
else
    print_error "requirements.txt not found!"
    exit 1
fi

# Step 3: Set Python Path
print_step "Setting up Python path..."
export PYTHONPATH="${PYTHONPATH}:$(pwd)"
echo "export PYTHONPATH=\"\${PYTHONPATH}:$(pwd)\"" >> ~/.bashrc
print_success "Python path configured"

# Step 4: Create necessary directories
print_step "Creating necessary directories..."
mkdir -p logs
mkdir -p data
mkdir -p temp
print_success "Directories created"

# Step 5: Test Application
print_step "Testing application components..."

# Test imports
python3 -c "
import sys
sys.path.append('.')
try:
    from app import app
    print('✅ Main application import successful')
except ImportError as e:
    print(f'❌ Main application import failed: {e}')
    
try:
    from utils import *
    print('✅ Utils import successful')
except ImportError as e:
    print(f'❌ Utils import failed: {e}')

try:
    from ai_engines import *
    print('✅ AI engines import successful')
except ImportError as e:
    print(f'❌ AI engines import failed: {e}')

try:
    from commands import *
    print('✅ Commands import successful')
except ImportError as e:
    print(f'❌ Commands import failed: {e}')
"

# Step 6: Create startup script
print_step "Creating Codespace startup script..."
cat > codespace-start.sh << 'EOL'
#!/bin/bash

# OB-1 Enhanced Capabilities - Codespace Startup Script
echo "🚀 Starting OB-1 Enhanced Capabilities in Codespace..."

# Set environment
export PYTHONPATH="${PYTHONPATH}:$(pwd)"
export FLASK_ENV=development
export PORT=5000

# Start the application
echo "🔥 Launching Flask application..."
python3 app.py &

# Store PID
APP_PID=$!
echo $APP_PID > .app.pid

echo "✅ OB-1 Enhanced Capabilities started!"
echo "🌐 Access your app at: https://${CODESPACE_NAME}-5000.${GITHUB_CODESPACES_PORT_FORWARDING_DOMAIN}"
echo "🔧 Stop with: kill $(cat .app.pid)"

# Wait for user input to stop
echo "Press Ctrl+C to stop the application"
wait $APP_PID
EOL

chmod +x codespace-start.sh
print_success "Startup script created"

# Step 7: Create health check script
print_step "Creating health check script..."
cat > health-check.py << 'EOL'
#!/usr/bin/env python3

import requests
import sys
import os
import time

def check_health():
    try:
        # Check if app is running
        port = os.environ.get('PORT', 5000)
        url = f"http://localhost:{port}/health"
        
        print(f"🔍 Checking health at {url}...")
        response = requests.get(url, timeout=5)
        
        if response.status_code == 200:
            print("✅ Application is healthy!")
            print(f"📊 Response: {response.json()}")
            return True
        else:
            print(f"❌ Health check failed with status: {response.status_code}")
            return False
            
    except requests.exceptions.ConnectionError:
        print("❌ Cannot connect to application. Is it running?")
        return False
    except Exception as e:
        print(f"❌ Health check error: {e}")
        return False

if __name__ == "__main__":
    if check_health():
        sys.exit(0)
    else:
        sys.exit(1)
EOL

chmod +x health-check.py
print_success "Health check script created"

# Step 8: Create VS Code configuration for Copilot fix
print_step "Creating VS Code configuration..."
mkdir -p .vscode

# Create VS Code settings to help with Copilot
cat > .vscode/settings.json << 'EOL'
{
    "python.defaultInterpreterPath": "/usr/bin/python3",
    "python.terminal.activateEnvironment": true,
    "github.copilot.enable": {
        "*": true,
        "plaintext": true,
        "markdown": true,
        "scminput": false
    },
    "github.copilot.advanced": {
        "debug.overrideEngine": "codex"
    },
    "terminal.integrated.env.linux": {
        "PYTHONPATH": "${workspaceFolder}"
    }
}
EOL

# Create VS Code extensions recommendations
cat > .vscode/extensions.json << 'EOL'
{
    "recommendations": [
        "github.copilot",
        "github.copilot-chat",
        "ms-python.python",
        "ms-python.flake8",
        "ms-python.black-formatter"
    ]
}
EOL

print_success "VS Code configuration created"

# Step 9: Final setup
print_step "Final setup and configuration..."

# Create quick commands script
cat > quick-commands.sh << 'EOL'
#!/bin/bash

# Quick commands for OB-1 Enhanced Capabilities

case "$1" in
    "start")
        echo "🚀 Starting OB-1 Enhanced Capabilities..."
        ./codespace-start.sh
        ;;
    "stop")
        echo "🛑 Stopping OB-1 Enhanced Capabilities..."
        if [ -f ".app.pid" ]; then
            kill $(cat .app.pid)
            rm .app.pid
            echo "✅ Application stopped"
        else
            echo "❌ No running application found"
        fi
        ;;
    "health")
        echo "🏥 Checking application health..."
        python3 health-check.py
        ;;
    "logs")
        echo "📋 Showing application logs..."
        tail -f logs/app.log 2>/dev/null || echo "No logs found"
        ;;
    "deploy")
        echo "🚀 Deploying to production..."
        ./deploy.sh
        ;;
    *)
        echo "🔧 OB-1 Enhanced Capabilities - Quick Commands"
        echo "Usage: $0 {start|stop|health|logs|deploy}"
        echo ""
        echo "Commands:"
        echo "  start   - Start the application in Codespace"
        echo "  stop    - Stop the running application"
        echo "  health  - Check application health"
        echo "  logs    - Show application logs"
        echo "  deploy  - Deploy to production"
        ;;
esac
EOL

chmod +x quick-commands.sh
print_success "Quick commands script created"

# Step 10: Update README for Codespace
print_step "Updating documentation..."
cat > CODESPACE_README.md << 'EOL'
# 🚀 OB-1 Enhanced Capabilities - Codespace Edition

## Quick Start in Codespace

### 1. Initial Setup (One-time)
```bash
# Run the builder script (already done!)
./codespace-builder.sh
```

### 2. Configure Environment
```bash
# Edit your .env file with your API keys
code .env

# Add your actual API keys:
# GITHUB_TOKEN=your_github_token_here
# OPENAI_API_KEY=your_openai_api_key_here
```

### 3. Start Application
```bash
# Quick start
./quick-commands.sh start

# Or manual start
python3 app.py
```

### 4. Access Your Application
Your app will be available at:
`https://${CODESPACE_NAME}-5000.${GITHUB_CODESPACES_PORT_FORWARDING_DOMAIN}`

## Quick Commands

- `./quick-commands.sh start` - Start the application
- `./quick-commands.sh stop` - Stop the application  
- `./quick-commands.sh health` - Check if app is running
- `./quick-commands.sh logs` - View application logs
- `./quick-commands.sh deploy` - Deploy to production

## VS Code Copilot Setup

1. **Install Extensions**: The required extensions should auto-install
2. **Sign In**: Use Command Palette (Ctrl+Shift+P) → "GitHub Copilot: Sign In"
3. **Test**: Create a new file and type `# function to` and press Tab

## Troubleshooting

### If Copilot fails:
1. Reload VS Code window (Ctrl+Shift+P → "Developer: Reload Window")
2. Check extensions are installed and enabled
3. Sign out and sign back in to GitHub Copilot

### If app fails to start:
1. Check logs: `./quick-commands.sh logs`
2. Verify environment: `python3 -c "import app; print('OK')"`
3. Check port forwarding in Codespace ports tab

## Development

- **Main App**: `app.py`
- **Configuration**: `config.yaml`
- **Environment**: `.env`
- **AI Engines**: `ai_engines/`
- **Commands**: `commands/`
- **Utils**: `utils/`

Happy coding with OB-1! 🤖
EOL

print_success "Documentation updated"

# Final message
echo ""
echo -e "${GREEN}
╔═══════════════════════════════════════════════════════════════════════════════╗
║                       🎉 SETUP COMPLETE! 🎉                                  ║
║                                                                               ║
║  Your OB-1 Enhanced Capabilities is ready to run in Codespace!              ║
║                                                                               ║
║  Next Steps:                                                                  ║
║  1. Configure your .env file with API keys                                   ║
║  2. Run: ./quick-commands.sh start                                           ║
║  3. Access your app via the forwarded port                                   ║
║                                                                               ║
║  For VS Code Copilot issues:                                                ║
║  - Extensions should auto-install                                            ║
║  - Use Ctrl+Shift+P → 'GitHub Copilot: Sign In'                            ║
║  - Reload window if needed                                                   ║
║                                                                               ║
╚═══════════════════════════════════════════════════════════════════════════════╝
${NC}"

print_success "🚀 Ready to launch! Run: ./quick-commands.sh start"