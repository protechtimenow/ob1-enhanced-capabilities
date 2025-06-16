#!/bin/bash

# OB-1 Enhanced AI GitHub App - Codespace Setup
# Run this in your GitHub Codespace terminal

set -e

echo "🚀 OB-1 Enhanced AI GitHub App - Codespace Setup"
echo "=================================================="

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

print_success() {
    echo -e "${GREEN}[✅]${NC} $1"
}

print_info() {
    echo -e "${BLUE}[ℹ️]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[⚠️]${NC} $1"
}

# Step 1: Navigate to workspace directory
cd /workspaces/ob1-enhanced-capabilities
print_success "Navigated to project directory"

# Step 2: Install dependencies
print_info "Installing Python dependencies..."
pip install --quiet flask requests cryptography PyJWT gunicorn python-dotenv
print_success "Dependencies installed"

# Step 3: Set up environment
if [ ! -f .env ]; then
    cp .env.example .env
    print_success "Created .env file from template"
else
    print_success ".env file already exists"
fi

# Step 4: Make scripts executable
chmod +x deploy.sh
print_success "Made deployment script executable"

# Step 5: Test the application
print_info "Testing application locally..."

# Set test environment variables
export FLASK_ENV=development
export GITHUB_APP_ID=12345
export GITHUB_WEBHOOK_SECRET=test-secret
export PORT=5000

# Kill any existing process on port 5000
pkill -f "python.*app.py" || true
sleep 2

# Start the app in background
python app.py &
APP_PID=$!
sleep 3

# Test endpoints
if curl -s http://localhost:5000/health > /dev/null; then
    print_success "✅ Application is running!"
    print_success "✅ Health endpoint working"
    
    # Test API
    if curl -s -X POST http://localhost:5000/api/analyze -H "Content-Type: application/json" -d '{"code":"test","file_path":"test.sol"}' > /dev/null; then
        print_success "✅ API endpoint working"
    fi
    
    # Stop the test instance
    kill $APP_PID 2>/dev/null || true
    print_success "✅ Local testing completed"
else
    print_warning "Application may have issues - check logs"
    kill $APP_PID 2>/dev/null || true
fi

echo ""
echo "=================================================="
echo "🎉 SETUP COMPLETE!"
echo "=================================================="
echo ""
echo "Your OB-1 Enhanced AI GitHub App is ready!"
echo ""
echo "🚀 NEXT STEPS:"
echo "1. Deploy:        ./deploy.sh"
echo "2. GitHub App:    https://github.com/settings/apps"
echo "3. Test it:       Create a PR with .sol files"
echo ""
echo "🔧 QUICK DEPLOY OPTIONS:"
echo "• Heroku:    heroku create your-app-name && git push heroku main"
echo "• Docker:    docker build -t ob1-ai . && docker run -p 5000:5000 ob1-ai"
echo "• Railway:   railway up"
echo ""
echo "📖 Full docs: README.md"
echo "✨ You're all set! Happy coding!"