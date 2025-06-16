#!/bin/bash

echo "🚀 Starting OB-1 Enhanced AI Fast Development Server"
echo "=================================================="

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

print_status() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

# Check if fast-dev-server.py exists, if not create it
if [ ! -f "fast-dev-server.py" ]; then
    print_info "Creating fast development server..."
    cat > fast-dev-server.py << 'EOF'
#!/usr/bin/env python3
"""
OB-1 Enhanced AI - Fast Development Server
Lightning-fast prototyping with hot reload
"""

import os
import json
from flask import Flask, request, jsonify, render_template_string
from dotenv import load_dotenv
import requests
import hashlib
import hmac

# Load environment variables
load_dotenv()

app = Flask(__name__)
app.config['DEBUG'] = True

# Configuration
GITHUB_TOKEN = os.getenv('GITHUB_TOKEN', '')
OPENAI_API_KEY = os.getenv('OPENAI_API_KEY', '')
USER_WALLET = os.getenv('USER_WALLET', '0x21cC30462B8392Aa250453704019800092a16165')
PORT = int(os.getenv('PORT', 5000))
HOST = os.getenv('HOST', '0.0.0.0')

# Simple HTML template for testing
HTML_TEMPLATE = """
<!DOCTYPE html>
<html>
<head>
    <title>OB-1 Enhanced AI - Fast Dev Server</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 40px; background: #1a1a1a; color: #fff; }
        .container { max-width: 800px; margin: 0 auto; }
        .status { padding: 20px; background: #2a2a2a; border-radius: 8px; margin: 20px 0; }
        .success { border-left: 4px solid #4CAF50; }
        .info { border-left: 4px solid #2196F3; }
        .warning { border-left: 4px solid #FF9800; }
        h1 { color: #4CAF50; }
        h2 { color: #2196F3; }
        .endpoint { background: #333; padding: 15px; margin: 10px 0; border-radius: 5px; }
        .method { color: #4CAF50; font-weight: bold; }
        pre { background: #1e1e1e; padding: 15px; overflow-x: auto; border-radius: 5px; }
        button { background: #4CAF50; color: white; border: none; padding: 10px 20px; border-radius: 5px; cursor: pointer; }
        button:hover { background: #45a049; }
        input, textarea { background: #333; color: white; border: 1px solid #555; padding: 10px; border-radius: 5px; width: 100%; box-sizing: border-box; }
    </style>
</head>
<body>
    <div class="container">
        <h1>🚀 OB-1 Enhanced AI - Fast Development Server</h1>
        
        <div class="status success">
            <h2>✅ Server Status: Running</h2>
            <p>Fast development mode enabled with hot reload</p>
            <p><strong>User Wallet:</strong> {{ user_wallet }}</p>
        </div>

        <div class="status info">
            <h2>🔗 Available Endpoints</h2>
            
            <div class="endpoint">
                <span class="method">GET</span> <code>/</code> - This dashboard
            </div>
            
            <div class="endpoint">
                <span class="method">GET</span> <code>/health</code> - Health check
            </div>
            
            <div class="endpoint">
                <span class="method">POST</span> <code>/analyze-contract</code> - Smart contract analysis
                <pre>{"contract_address": "0x...", "chain": "ethereum"}</pre>
            </div>
            
            <div class="endpoint">
                <span class="method">POST</span> <code>/ai-chat</code> - AI conversation
                <pre>{"message": "Analyze this smart contract", "context": "blockchain"}</pre>
            </div>
            
            <div class="endpoint">
                <span class="method">POST</span> <code>/webhook</code> - GitHub webhook handler
            </div>
        </div>

        <div class="status warning">
            <h2>⚡ Quick Tests</h2>
            <p>Test the AI endpoints directly:</p>
            
            <h3>Test Smart Contract Analysis:</h3>
            <textarea id="contractInput" placeholder='{"contract_address": "0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48", "chain": "ethereum"}'></textarea>
            <button onclick="testContract()">Test Contract Analysis</button>
            
            <h3>Test AI Chat:</h3>
            <textarea id="chatInput" placeholder='{"message": "What is the gas cost of a simple ERC20 transfer?", "context": "blockchain"}'></textarea>
            <button onclick="testChat()">Test AI Chat</button>
            
            <h3>Results:</h3>
            <pre id="results">Results will appear here...</pre>
        </div>
    </div>

    <script>
        async function testContract() {
            const input = document.getElementById('contractInput').value;
            try {
                const response = await fetch('/analyze-contract', {
                    method: 'POST',
                    headers: {'Content-Type': 'application/json'},
                    body: input
                });
                const result = await response.json();
                document.getElementById('results').textContent = JSON.stringify(result, null, 2);
            } catch (error) {
                document.getElementById('results').textContent = 'Error: ' + error.message;
            }
        }

        async function testChat() {
            const input = document.getElementById('chatInput').value;
            try {
                const response = await fetch('/ai-chat', {
                    method: 'POST',
                    headers: {'Content-Type': 'application/json'},
                    body: input
                });
                const result = await response.json();
                document.getElementById('results').textContent = JSON.stringify(result, null, 2);
            } catch (error) {
                document.getElementById('results').textContent = 'Error: ' + error.message;
            }
        }
    </script>
</body>
</html>
"""

@app.route('/')
def dashboard():
    """Main dashboard for development"""
    return render_template_string(HTML_TEMPLATE, user_wallet=USER_WALLET)

@app.route('/health')
def health():
    """Health check endpoint"""
    return jsonify({
        "status": "healthy",
        "mode": "development",
        "user_wallet": USER_WALLET,
        "github_configured": bool(GITHUB_TOKEN),
        "openai_configured": bool(OPENAI_API_KEY),
        "fast_dev": True
    })

@app.route('/analyze-contract', methods=['POST'])
def analyze_contract():
    """Smart contract analysis endpoint"""
    try:
        data = request.json or {}
        contract_address = data.get('contract_address', '')
        chain = data.get('chain', 'ethereum')
        
        # Mock analysis for fast development
        analysis = {
            "contract_address": contract_address,
            "chain": chain,
            "analysis": {
                "verified": True,
                "security_score": 85,
                "gas_efficiency": "Good",
                "findings": [
                    "Contract appears to be a standard ERC20 token",
                    "No obvious security vulnerabilities detected",
                    "Gas optimization opportunities available"
                ],
                "recommendations": [
                    "Consider implementing additional access controls",
                    "Add events for better tracking",
                    "Optimize storage variables for gas efficiency"
                ]
            },
            "ai_analysis": "This contract shows standard ERC20 implementation patterns with good security practices.",
            "user_wallet": USER_WALLET,
            "fast_dev_mode": True
        }
        
        return jsonify(analysis)
        
    except Exception as e:
        return jsonify({"error": str(e), "fast_dev_mode": True}), 500

@app.route('/ai-chat', methods=['POST'])
def ai_chat():
    """AI chat endpoint for blockchain questions"""
    try:
        data = request.json or {}
        message = data.get('message', '')
        context = data.get('context', 'blockchain')
        
        # Mock AI response for fast development
        responses = {
            "gas": "Gas costs for ERC20 transfers typically range from 21,000 to 65,000 gas units, depending on the implementation.",
            "defi": "DeFi protocols use automated market makers (AMMs) and liquidity pools to enable decentralized trading.",
            "security": "Smart contract security involves checking for reentrancy attacks, overflow/underflow, and access controls.",
            "default": f"I understand you're asking about: {message}. In fast development mode, I can help with blockchain analysis, smart contracts, and DeFi protocols."
        }
        
        # Simple keyword matching for demo
        response_text = responses["default"]
        for keyword, response in responses.items():
            if keyword in message.lower():
                response_text = response
                break
        
        return jsonify({
            "response": response_text,
            "user_message": message,
            "context": context,
            "user_wallet": USER_WALLET,
            "ai_engine": "OB-1 Fast Dev",
            "timestamp": json.dumps(None, default=str)
        })
        
    except Exception as e:
        return jsonify({"error": str(e), "fast_dev_mode": True}), 500

@app.route('/webhook', methods=['POST'])
def webhook():
    """GitHub webhook handler"""
    try:
        payload = request.json or {}
        event_type = request.headers.get('X-GitHub-Event', 'unknown')
        
        response = {
            "event_type": event_type,
            "action": payload.get('action', 'unknown'),
            "repository": payload.get('repository', {}).get('name', 'unknown'),
            "processed": True,
            "fast_dev_mode": True,
            "message": f"Webhook received: {event_type} event processed successfully"
        }
        
        return jsonify(response)
        
    except Exception as e:
        return jsonify({"error": str(e), "fast_dev_mode": True}), 500

@app.route('/blockchain-query', methods=['POST'])
def blockchain_query():
    """Blockchain data query endpoint"""
    try:
        data = request.json or {}
        query_type = data.get('type', 'balance')
        address = data.get('address', USER_WALLET)
        
        # Mock blockchain data for fast development
        mock_data = {
            "balance": {
                "address": address,
                "eth_balance": "1.234 ETH",
                "token_count": 5,
                "tokens": ["USDC", "DAI", "WETH", "UNI", "LINK"]
            },
            "transactions": {
                "address": address,
                "recent_transactions": 3,
                "last_activity": "2 hours ago"
            },
            "nfts": {
                "address": address,
                "nft_count": 2,
                "collections": ["CryptoPunks", "Bored Apes"]
            }
        }
        
        result = mock_data.get(query_type, {"error": "Unknown query type"})
        result["fast_dev_mode"] = True
        
        return jsonify(result)
        
    except Exception as e:
        return jsonify({"error": str(e), "fast_dev_mode": True}), 500

if __name__ == '__main__':
    print("🚀 Starting OB-1 Enhanced AI Fast Development Server")
    print("=" * 60)
    print(f"🔗 Dashboard: http://{HOST}:{PORT}")
    print(f"💼 User Wallet: {USER_WALLET}")
    print(f"🔧 Mode: Fast Development with Hot Reload")
    print("=" * 60)
    
    app.run(
        host=HOST,
        port=PORT,
        debug=True,
        use_reloader=True,
        threaded=True
    )
EOF
    print_status "Fast development server created"
fi

# Load environment variables
if [ -f ".env" ]; then
    export $(grep -v '^#' .env | xargs)
fi

# Set default values if not in .env
export PORT=${PORT:-5000}
export HOST=${HOST:-0.0.0.0}
export FLASK_ENV=${FLASK_ENV:-development}

print_info "Starting server on http://$HOST:$PORT"
print_info "Environment: $FLASK_ENV"

# Kill any existing process on the port
print_info "Checking for existing processes on port $PORT..."
if lsof -ti:$PORT >/dev/null 2>&1; then
    print_warning "Killing existing process on port $PORT"
    kill -9 $(lsof -ti:$PORT) 2>/dev/null || true
    sleep 2
fi

# Start the fast development server
print_status "Launching OB-1 Fast Development Server..."
echo
python3 fast-dev-server.py