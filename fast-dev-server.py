#!/usr/bin/env python3
"""
🚀 OB-1 Enhanced AI - Fast Development Server
Super quick prototyping environment for GitHub Codespaces
"""

import os
import sys
import subprocess
from flask import Flask, request, jsonify
import logging
import threading
import time

# Configure logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(levelname)s - %(message)s'
)
logger = logging.getLogger(__name__)

# Create Flask app
app = Flask(__name__)
app.config['DEBUG'] = True

class OB1FastPrototype:
    def __init__(self):
        self.version = "1.0.0-dev"
        self.env = "development"
        
    def analyze_smart_contract(self, code):
        """Fast smart contract analysis for prototyping"""
        analysis = {
            "security_issues": [],
            "gas_optimizations": [],
            "best_practices": [],
            "complexity_score": 0
        }
        
        # Quick analysis patterns
        if "transfer(" in code:
            analysis["security_issues"].append("Consider using SafeTransfer")
        if "require(" not in code:
            analysis["security_issues"].append("Add input validation with require()")
        if "pragma solidity" in code:
            analysis["best_practices"].append("Pragma version detected")
            
        analysis["complexity_score"] = len(code.split('\n'))
        return analysis
    
    def blockchain_query(self, query):
        """Fast blockchain query simulation"""
        return {
            "query": query,
            "result": "Simulated blockchain data for fast prototyping",
            "timestamp": time.time(),
            "network": "development"
        }

# Initialize OB-1
ob1 = OB1FastPrototype()

@app.route('/')
def home():
    return jsonify({
        "service": "OB-1 Enhanced AI - Fast Dev Server",
        "version": ob1.version,
        "environment": ob1.env,
        "status": "🚀 Ready for fast prototyping!",
        "endpoints": [
            "/health",
            "/analyze-contract",
            "/blockchain-query",
            "/ai-chat",
            "/webhook"
        ]
    })

@app.route('/health')
def health():
    return jsonify({
        "status": "healthy",
        "uptime": time.time(),
        "message": "⚡ Fast dev server running!"
    })

@app.route('/analyze-contract', methods=['POST'])
def analyze_contract():
    try:
        data = request.get_json()
        contract_code = data.get('code', '')
        
        analysis = ob1.analyze_smart_contract(contract_code)
        
        return jsonify({
            "success": True,
            "analysis": analysis,
            "message": "🔍 Contract analyzed successfully"
        })
    except Exception as e:
        return jsonify({
            "success": False,
            "error": str(e),
            "message": "❌ Analysis failed"
        }), 500

@app.route('/blockchain-query', methods=['POST'])
def blockchain_query():
    try:
        data = request.get_json()
        query = data.get('query', '')
        
        result = ob1.blockchain_query(query)
        
        return jsonify({
            "success": True,
            "result": result,
            "message": "⛓️ Blockchain query executed"
        })
    except Exception as e:
        return jsonify({
            "success": False,
            "error": str(e),
            "message": "❌ Query failed"
        }), 500

@app.route('/ai-chat', methods=['POST'])
def ai_chat():
    try:
        data = request.get_json()
        message = data.get('message', '')
        
        # Fast AI response simulation
        response = f"🤖 OB-1 AI Response to: '{message}' - This is fast prototyping mode!"
        
        return jsonify({
            "success": True,
            "response": response,
            "timestamp": time.time(),
            "message": "💬 AI chat response generated"
        })
    except Exception as e:
        return jsonify({
            "success": False,
            "error": str(e),
            "message": "❌ AI chat failed"
        }), 500

@app.route('/webhook', methods=['POST'])
def webhook():
    """GitHub webhook endpoint for fast testing"""
    try:
        payload = request.get_json()
        event_type = request.headers.get('X-GitHub-Event', 'unknown')
        
        logger.info(f"📡 Webhook received: {event_type}")
        
        return jsonify({
            "success": True,
            "event": event_type,
            "message": "🔗 Webhook processed successfully"
        })
    except Exception as e:
        return jsonify({
            "success": False,
            "error": str(e),
            "message": "❌ Webhook processing failed"
        }), 500

def check_port_available(port):
    """Check if a port is available for use"""
    import socket
    try:
        with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s:
            s.bind(('localhost', port))
            return True
    except OSError:
        return False

def start_dev_server():
    """Start the fast development server"""
    port = 5000
    
    # Find available port
    while not check_port_available(port) and port < 5010:
        port += 1
    
    print(f"""
🚀 OB-1 Enhanced AI - Fast Development Server
==============================================

✅ Environment: Development (Fast Prototyping)
✅ Port: {port}
✅ Debug Mode: Enabled
✅ Auto-reload: Enabled

🌐 ACCESS METHODS:
------------------
📱 Codespace Preview: Click 'Ports' tab → Open port {port}
🔗 Direct URL: https://your-codespace-url-{port}
🧪 Local Testing: http://localhost:{port}

📡 ENDPOINTS:
------------
🏠 Home: /
❤️ Health: /health
🔍 Analyze: /analyze-contract
⛓️ Query: /blockchain-query
💬 AI Chat: /ai-chat
🔗 Webhook: /webhook

⚡ FAST PROTOTYPING READY!
========================
    """)
    
    # Start Flask with hot reload
    app.run(
        host='0.0.0.0',
        port=port,
        debug=True,
        use_reloader=True,
        threaded=True
    )

if __name__ == '__main__':
    start_dev_server()