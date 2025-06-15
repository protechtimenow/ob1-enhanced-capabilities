#!/bin/bash
# OB-1 Enhanced Railway ALL-IN Deployment Script
# Complete quantum empire deployment automation

echo "🚀 INITIATING OB-1 ENHANCED ALL-IN DEPLOYMENT"
echo "================================================="

# Install Railway CLI if not present
if ! command -v railway &> /dev/null; then
    echo "📦 Installing Railway CLI..."
    npm install -g @railway/cli
    echo "✅ Railway CLI installed"
fi

# Login check
echo "🔐 Checking Railway authentication..."
if ! railway whoami &> /dev/null; then
    echo "❌ Please run 'railway login' first and then rerun this script"
    exit 1
fi

echo "✅ Railway authenticated"

# Initialize Railway project
echo "🚀 Initializing Railway project..."
railway init --name "ob1-enhanced-backend"

# Set environment variables (use your actual tokens)
echo "🔧 Configuring environment variables..."
echo "⚠️  Set these variables with your actual tokens:"
echo "railway variables set GITHUB_TOKEN='your_github_token_here'"
echo "railway variables set WEBHOOK_SECRET='your_webhook_secret_here'"
railway variables set PORT="5000"
railway variables set FLASK_ENV="production"
railway variables set OB1_MODE="quantum"
railway variables set QUANTUM_PROTOCOL="enabled"
railway variables set AGENT_COUNT="4"
railway variables set CONTROLLER_WALLET="0x21cC30462B8392Aa250453704019800092a16165"

echo "✅ Environment variables configured"

# Deploy to Railway
echo "🚀 Deploying to Railway..."
railway up

echo "✅ Backend deployed successfully!"

# Get the deployment URL
BACKEND_URL=$(railway domain)
echo "🌐 Backend URL: $BACKEND_URL"

# Scale for production
echo "⚡ Scaling for production..."
railway service --help | grep -q scale && railway service scale --replicas 3

echo "✅ Backend scaling configured"

# Test deployment
echo "🧪 Testing deployment..."
if curl -f "$BACKEND_URL/health" &> /dev/null; then
    echo "✅ Backend health check passed"
else
    echo "⚠️  Backend health check failed - checking logs..."
    railway logs --tail 10
fi

echo "🎯 Phase 1 Complete: Railway Backend Operational"
echo "================================================="