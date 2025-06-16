#!/bin/bash
# OB-1 Enhanced Capabilities - GitHub App Deployment Script
# Converts your VS Code extension project into a professional GitHub App

set -e

echo "🚀 OB-1 Enhanced Capabilities - GitHub App Deployment"
echo "=================================================="

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Check if in correct directory
if [ ! -f "github_app/app.py" ]; then
    echo -e "${RED}❌ Error: Please run this script from the root of ob1-enhanced-capabilities repository${NC}"
    exit 1
fi

echo -e "${BLUE}📋 Setting up deployment environment...${NC}"

# Create deployment directory
mkdir -p deploy_github_app
cd deploy_github_app

# Copy GitHub App files
echo -e "${YELLOW}📁 Copying GitHub App files...${NC}"
cp -r ../github_app/* .
cp -r ../ai_engines .
cp -r ../commands .
cp -r ../utils .
cp ../config.yaml .

# Create Procfile for Heroku
echo -e "${YELLOW}📄 Creating Procfile...${NC}"
cat > Procfile << EOF
web: gunicorn app:app --bind 0.0.0.0:\$PORT --workers 3
EOF

# Create runtime.txt for Python version
echo -e "${YELLOW}🐍 Setting Python runtime...${NC}"
cat > runtime.txt << EOF
python-3.9.18
EOF

# Create app.json for Heroku
echo -e "${YELLOW}⚙️ Creating Heroku configuration...${NC}"
cat > app.json << EOF
{
  "name": "OB-1 Enhanced AI Capabilities",
  "description": "Powerful AI-driven blockchain development assistant for GitHub",
  "repository": "https://github.com/protechtimenow/ob1-enhanced-capabilities",
  "logo": "https://avatars.githubusercontent.com/u/protechtimenow",
  "keywords": [
    "ai",
    "blockchain",
    "ethereum",
    "smart-contracts",
    "defi",
    "github-app"
  ],
  "env": {
    "GITHUB_APP_ID": {
      "description": "GitHub App ID (get from GitHub App settings)",
      "required": true
    },
    "GITHUB_PRIVATE_KEY": {
      "description": "GitHub App Private Key (base64 encoded)",
      "required": true
    },
    "GITHUB_WEBHOOK_SECRET": {
      "description": "GitHub Webhook Secret",
      "required": true
    },
    "OPENAI_API_KEY": {
      "description": "OpenAI API Key for AI capabilities",
      "required": false
    },
    "FLASK_ENV": {
      "value": "production"
    }
  },
  "formation": {
    "web": {
      "quantity": 1,
      "size": "hobby"
    }
  },
  "buildpacks": [
    {
      "url": "heroku/python"
    }
  ],
  "addons": [
    {
      "plan": "heroku-redis:mini"
    }
  ]
}
EOF

# Create Docker deployment option
echo -e "${YELLOW}🐳 Creating Dockerfile...${NC}"
cat > Dockerfile << EOF
FROM python:3.9-slim

WORKDIR /app

# Install system dependencies
RUN apt-get update && apt-get install -y \\
    gcc \\
    g++ \\
    && rm -rf /var/lib/apt/lists/*

# Copy requirements and install Python dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy application code
COPY . .

# Set environment variables
ENV FLASK_APP=app.py
ENV FLASK_ENV=production
ENV PYTHONPATH=/app

# Expose port
EXPOSE 5000

# Run the application
CMD ["gunicorn", "--bind", "0.0.0.0:5000", "--workers", "3", "app:app"]
EOF

# Create docker-compose for local development
cat > docker-compose.yml << EOF
version: '3.8'

services:
  web:
    build: .
    ports:
      - "5000:5000"
    environment:
      - GITHUB_APP_ID=\${GITHUB_APP_ID}
      - GITHUB_PRIVATE_KEY=\${GITHUB_PRIVATE_KEY}
      - GITHUB_WEBHOOK_SECRET=\${GITHUB_WEBHOOK_SECRET}
      - OPENAI_API_KEY=\${OPENAI_API_KEY}
      - REDIS_URL=redis://redis:6379
    depends_on:
      - redis
    volumes:
      - .:/app
    command: python app.py

  redis:
    image: redis:alpine
    ports:
      - "6379:6379"
EOF

# Initialize git repository for deployment
echo -e "${YELLOW}🔧 Initializing deployment repository...${NC}"
git init
git add .
git commit -m "Initial GitHub App deployment setup"

echo -e "${GREEN}✅ GitHub App deployment setup complete!${NC}"
echo ""
echo -e "${BLUE}🚀 Deployment Options:${NC}"
echo ""

# Heroku deployment instructions
echo -e "${YELLOW}Option 1: Deploy to Heroku${NC}"
echo "1. Install Heroku CLI: https://devcenter.heroku.com/articles/heroku-cli"
echo "2. Create Heroku app:"
echo "   heroku create ob1-enhanced-app"
echo "3. Set environment variables:"
echo "   heroku config:set GITHUB_APP_ID=your_app_id"
echo "   heroku config:set GITHUB_PRIVATE_KEY=\"your_private_key\""
echo "   heroku config:set GITHUB_WEBHOOK_SECRET=your_webhook_secret"
echo "4. Deploy:"
echo "   git push heroku main"
echo ""

# Railway deployment instructions
echo -e "${YELLOW}Option 2: Deploy to Railway${NC}"
echo "1. Install Railway CLI: npm install -g @railway/cli"
echo "2. Login: railway login"
echo "3. Deploy: railway up"
echo "4. Set environment variables in Railway dashboard"
echo ""

# Manual deployment instructions
echo -e "${YELLOW}Option 3: Manual Server Deployment${NC}"
echo "1. Copy files to your server"
echo "2. Install dependencies: pip install -r requirements.txt"
echo "3. Set environment variables"
echo "4. Run: gunicorn app:app --bind 0.0.0.0:5000"
echo ""

# GitHub App creation instructions
echo -e "${BLUE}📱 Create GitHub App:${NC}"
echo "1. Go to: https://github.com/settings/apps"
echo "2. Click 'New GitHub App'"
echo "3. Fill in details:"
echo "   - App Name: OB-1 Enhanced Capabilities"
echo "   - Homepage URL: https://your-app-domain.com"
echo "   - Webhook URL: https://your-app-domain.com/webhook"
echo "4. Set permissions (see app.yaml for details)"
echo "5. Generate private key and webhook secret"
echo "6. Install the app on your repositories"
echo ""

echo -e "${GREEN}🎉 Your OB-1 Enhanced Capabilities is ready to become a GitHub App!${NC}"
echo -e "${BLUE}Next steps:${NC}"
echo "1. Choose a deployment option above"
echo "2. Create your GitHub App"
echo "3. Install and test on repositories"
echo ""
echo -e "${YELLOW}💡 Tip: Start with Heroku for the easiest deployment experience!${NC}"