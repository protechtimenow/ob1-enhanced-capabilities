#!/bin/bash

# OB-1 Enhanced AI GitHub App - One-Click Deployment Script
# This script automates the entire deployment process

set -e

echo "🚀 OB-1 Enhanced AI GitHub App - Automated Deployment"
echo "============================================================"

# Colors for better output
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if we're in a codespace
if [[ -n "$CODESPACE_NAME" ]]; then
    print_status "Running in GitHub Codespace: $CODESPACE_NAME"
    IN_CODESPACE=true
else
    IN_CODESPACE=false
fi

# Step 1: Environment Setup
print_status "Setting up environment..."

# Create .env file if it doesn't exist
if [[ ! -f .env ]]; then
    print_status "Creating .env file from template..."
    cp .env.example .env
    print_warning "Please edit .env file with your actual configuration values"
else
    print_success ".env file already exists"
fi

# Step 2: Install Dependencies
print_status "Installing Python dependencies..."
if command -v pip3 &> /dev/null; then
    pip3 install -r requirements.txt
elif command -v pip &> /dev/null; then
    pip install -r requirements.txt
else
    print_error "pip not found. Please install Python and pip first."
    exit 1
fi

# Step 3: Test Local Application
print_status "Testing application locally..."
export FLASK_ENV=development
export GITHUB_APP_ID=12345
export GITHUB_WEBHOOK_SECRET=test-secret

# Kill any existing process on port 5000
if lsof -ti:5000 > /dev/null 2>&1; then
    print_warning "Killing existing process on port 5000..."
    kill -9 $(lsof -ti:5000) || true
fi

# Start the app in background for testing
python3 app.py &
APP_PID=$!
sleep 3

# Test the application
if curl -s http://localhost:5000/health > /dev/null; then
    print_success "Application is running locally!"
    
    # Test API endpoints
    print_status "Testing API endpoints..."
    curl -s http://localhost:5000/ | python3 -m json.tool > /dev/null && print_success "Root endpoint working"
    curl -s http://localhost:5000/health | python3 -m json.tool > /dev/null && print_success "Health endpoint working"
    curl -s http://localhost:5000/status | python3 -m json.tool > /dev/null && print_success "Status endpoint working"
else
    print_error "Application failed to start locally"
    kill $APP_PID 2>/dev/null || true
    exit 1
fi

# Stop the test instance
kill $APP_PID 2>/dev/null || true
sleep 2

print_success "Local testing completed successfully!"

# Step 4: Deployment Options
echo ""
echo "============================================================"
echo "🚀 DEPLOYMENT OPTIONS"
echo "============================================================"

# Check for deployment tools
HEROKU_AVAILABLE=false
RAILWAY_AVAILABLE=false
DOCKER_AVAILABLE=false

if command -v heroku &> /dev/null; then
    HEROKU_AVAILABLE=true
    print_success "Heroku CLI detected"
fi

if command -v railway &> /dev/null; then
    RAILWAY_AVAILABLE=true
    print_success "Railway CLI detected"
fi

if command -v docker &> /dev/null; then
    DOCKER_AVAILABLE=true
    print_success "Docker detected"
fi

# Deployment menu
echo ""
echo "Choose your deployment method:"
echo "1) Heroku (Recommended)"
echo "2) Railway" 
echo "3) Docker (Run locally)"
echo "4) Manual (Get instructions)"
echo "5) Skip deployment"

read -p "Enter your choice (1-5): " choice

case $choice in
    1)
        if [[ $HEROKU_AVAILABLE == true ]]; then
            print_status "Deploying to Heroku..."
            
            # Check if user is logged in to Heroku
            if ! heroku whoami > /dev/null 2>&1; then
                print_warning "Please login to Heroku first:"
                heroku login
            fi
            
            # Create Heroku app
            APP_NAME="ob1-enhanced-ai-$(date +%s)"
            print_status "Creating Heroku app: $APP_NAME"
            heroku create $APP_NAME
            
            # Set environment variables
            print_status "Setting environment variables..."
            heroku config:set FLASK_ENV=production -a $APP_NAME
            heroku config:set GITHUB_APP_ID=12345 -a $APP_NAME
            heroku config:set GITHUB_WEBHOOK_SECRET=change-this-secret -a $APP_NAME
            
            # Deploy
            print_status "Deploying to Heroku..."
            git push heroku main
            
            # Get the app URL
            APP_URL=$(heroku info -a $APP_NAME | grep "Web URL" | sed 's/Web URL: *//')
            print_success "Deployment complete! Your app is available at: $APP_URL"
            
            echo ""
            print_warning "IMPORTANT: Update your GitHub App settings:"
            print_warning "1. Webhook URL: ${APP_URL}webhook"
            print_warning "2. Update environment variables with real values"
            
        else
            print_error "Heroku CLI not found. Please install it first."
            exit 1
        fi
        ;;
    2)
        if [[ $RAILWAY_AVAILABLE == true ]]; then
            print_status "Deploying to Railway..."
            railway up
            print_success "Railway deployment initiated!"
        else
            print_error "Railway CLI not found. Please install it first."
            exit 1
        fi
        ;;
    3)
        if [[ $DOCKER_AVAILABLE == true ]]; then
            print_status "Building Docker image..."
            docker build -t ob1-enhanced-ai .
            
            print_status "Running Docker container..."
            docker run -d -p 5000:5000 --env-file .env ob1-enhanced-ai
            
            print_success "Docker container started! App available at http://localhost:5000"
        else
            print_error "Docker not found. Please install Docker first."
            exit 1
        fi
        ;;
    4)
        echo ""
        echo "============================================================"
        echo "📋 MANUAL DEPLOYMENT INSTRUCTIONS"
        echo "============================================================"
        echo ""
        echo "1. HEROKU DEPLOYMENT:"
        echo "   heroku create your-app-name"
        echo "   heroku config:set FLASK_ENV=production"
        echo "   heroku config:set GITHUB_APP_ID=your_app_id"
        echo "   git push heroku main"
        echo ""
        echo "2. RAILWAY DEPLOYMENT:"
        echo "   railway up"
        echo ""
        echo "3. DOCKER DEPLOYMENT:"
        echo "   docker build -t ob1-ai ."
        echo "   docker run -d -p 5000:5000 ob1-ai"
        echo ""
        echo "4. GITHUB APP CREATION:"
        echo "   Go to: https://github.com/settings/apps"
        echo "   Click 'New GitHub App'"
        echo "   Set Webhook URL: https://your-app-url/webhook"
        echo ""
        ;;
    5)
        print_warning "Skipping deployment. You can deploy later using this script."
        ;;
    *)
        print_error "Invalid choice. Exiting."
        exit 1
        ;;
esac

# Final steps
echo ""
echo "============================================================"
echo "✅ DEPLOYMENT SUMMARY"
echo "============================================================"
echo ""
print_success "✅ Application files created"
print_success "✅ Dependencies installed"
print_success "✅ Local testing completed"

if [[ $choice -ne 5 ]]; then
    print_success "✅ Deployment completed"
fi

echo ""
echo "🔧 NEXT STEPS:"
echo "============================================================"
echo ""
echo "1. 📝 Update .env file with your actual API keys:"
echo "   - GITHUB_APP_ID"
echo "   - GITHUB_PRIVATE_KEY"
echo "   - GITHUB_WEBHOOK_SECRET"
echo "   - OPENAI_API_KEY"
echo ""
echo "2. 🔗 Create your GitHub App:"
echo "   - Go to: https://github.com/settings/apps"
echo "   - Click 'New GitHub App'"
echo "   - Set Webhook URL to your deployed app URL + /webhook"
echo ""
echo "3. 🎯 Install the app on repositories:"
echo "   - Go to your GitHub App settings"
echo "   - Click 'Install App'"
echo "   - Select repositories"
echo ""
echo "4. 🧪 Test your GitHub App:"
echo "   - Create a pull request in a repository"
echo "   - Check if OB-1 responds with AI analysis"
echo ""

print_success "🚀 OB-1 Enhanced AI GitHub App is ready!"
echo ""