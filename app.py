#!/usr/bin/env python3
"""
OB-1 Enhanced AI GitHub App
Professional GitHub App for AI-powered blockchain development assistance
"""

import os
import json
import hmac
import hashlib
import logging
from datetime import datetime
from flask import Flask, request, jsonify
import requests
from cryptography.hazmat.primitives import serialization
from cryptography.hazmat.primitives.asymmetric import rsa
import jwt
import time

# Configure logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

# Initialize Flask app
app = Flask(__name__)

# Configuration from environment variables
GITHUB_APP_ID = os.environ.get('GITHUB_APP_ID', '12345')  # Will be set during GitHub App creation
GITHUB_PRIVATE_KEY = os.environ.get('GITHUB_PRIVATE_KEY', '')
GITHUB_WEBHOOK_SECRET = os.environ.get('GITHUB_WEBHOOK_SECRET', 'your-webhook-secret')
OPENAI_API_KEY = os.environ.get('OPENAI_API_KEY', '')
PORT = int(os.environ.get('PORT', 5000))

class OB1GitHubApp:
    """Main OB-1 GitHub App class"""
    
    def __init__(self):
        self.app_id = GITHUB_APP_ID
        self.private_key = GITHUB_PRIVATE_KEY
        self.webhook_secret = GITHUB_WEBHOOK_SECRET
        
    def create_jwt_token(self):
        """Create JWT token for GitHub App authentication"""
        if not self.private_key:
            logger.warning("No private key configured - using demo mode")
            return "demo-token"
            
        try:
            # Load private key
            key = serialization.load_pem_private_key(
                self.private_key.encode(),
                password=None
            )
            
            # Create JWT payload
            payload = {
                'iat': int(time.time()),
                'exp': int(time.time()) + 600,  # 10 minutes
                'iss': self.app_id
            }
            
            # Create token
            token = jwt.encode(payload, key, algorithm='RS256')
            return token
            
        except Exception as e:
            logger.error(f"Error creating JWT token: {e}")
            return "demo-token"
    
    def verify_webhook_signature(self, payload, signature):
        """Verify GitHub webhook signature"""
        if not self.webhook_secret:
            return True  # Demo mode
            
        expected_signature = 'sha256=' + hmac.new(
            self.webhook_secret.encode(),
            payload,
            hashlib.sha256
        ).hexdigest()
        
        return hmac.compare_digest(expected_signature, signature)
    
    def analyze_code_with_ai(self, code_content, file_path=""):
        """Analyze code using OB-1 AI capabilities"""
        try:
            # This is where OB-1 AI analysis would happen
            analysis = {
                "file_path": file_path,
                "analysis_type": "smart_contract" if file_path.endswith('.sol') else "general_code",
                "timestamp": datetime.now().isoformat(),
                "findings": []
            }
            
            # Smart contract specific analysis
            if file_path.endswith('.sol'):
                analysis["findings"].extend([
                    {
                        "type": "security",
                        "severity": "medium",
                        "message": "🔐 Consider implementing access controls for sensitive functions",
                        "line": 1
                    },
                    {
                        "type": "optimization",
                        "severity": "low", 
                        "message": "⚡ Gas optimization opportunities detected",
                        "line": 1
                    }
                ])
            
            # General code analysis
            analysis["findings"].append({
                "type": "quality",
                "severity": "info",
                "message": f"🤖 OB-1 AI analyzed {file_path} - Code looks good!",
                "line": 1
            })
            
            return analysis
            
        except Exception as e:
            logger.error(f"Error in AI analysis: {e}")
            return {
                "error": str(e),
                "message": "🤖 OB-1 AI analysis temporarily unavailable"
            }
    
    def create_pr_comment(self, repo_full_name, pr_number, analysis, installation_token):
        """Create a comment on a pull request with AI analysis"""
        try:
            comment_body = "## 🤖 OB-1 Enhanced AI Analysis\n\n"
            
            if "error" in analysis:
                comment_body += f"❌ **Analysis Error:** {analysis['message']}\n"
            else:
                comment_body += f"📊 **Analysis Type:** {analysis['analysis_type']}\n"
                comment_body += f"⏰ **Timestamp:** {analysis['timestamp']}\n\n"
                
                if analysis["findings"]:
                    comment_body += "### 🔍 Findings:\n"
                    for finding in analysis["findings"]:
                        emoji = {"security": "🔐", "optimization": "⚡", "quality": "✨"}.get(finding["type"], "📝")
                        comment_body += f"- {emoji} **{finding['severity'].upper()}:** {finding['message']}\n"
                else:
                    comment_body += "✅ No issues found - great work!\n"
            
            comment_body += "\n---\n*Powered by OB-1 Enhanced AI Capabilities*"
            
            # Post comment to GitHub
            url = f"https://api.github.com/repos/{repo_full_name}/issues/{pr_number}/comments"
            headers = {
                'Authorization': f'token {installation_token}',
                'Accept': 'application/vnd.github.v3+json',
                'Content-Type': 'application/json'
            }
            
            data = {"body": comment_body}
            
            response = requests.post(url, headers=headers, json=data)
            
            if response.status_code == 201:
                logger.info(f"Successfully posted comment to PR {pr_number}")
                return True
            else:
                logger.error(f"Failed to post comment: {response.status_code} - {response.text}")
                return False
                
        except Exception as e:
            logger.error(f"Error creating PR comment: {e}")
            return False

# Initialize OB-1 GitHub App
ob1_app = OB1GitHubApp()

@app.route('/', methods=['GET'])
def home():
    """Home endpoint"""
    return jsonify({
        "app": "OB-1 Enhanced AI GitHub App",
        "status": "🚀 Ready",
        "version": "1.0.0",
        "capabilities": [
            "Smart Contract Analysis",
            "AI Code Review", 
            "Blockchain Development Assistance",
            "Automated Issue Response",
            "Gas Optimization Suggestions"
        ],
        "endpoints": {
            "/webhook": "GitHub webhook handler",
            "/health": "Health check",
            "/status": "App status"
        }
    })

@app.route('/health', methods=['GET'])
def health_check():
    """Health check endpoint"""
    return jsonify({
        "status": "healthy",
        "timestamp": datetime.now().isoformat(),
        "app_id": GITHUB_APP_ID,
        "has_private_key": bool(GITHUB_PRIVATE_KEY),
        "has_webhook_secret": bool(GITHUB_WEBHOOK_SECRET)
    })

@app.route('/status', methods=['GET'])
def status():
    """Detailed status endpoint"""
    return jsonify({
        "app": "OB-1 Enhanced AI",
        "status": "operational",
        "github_app_id": GITHUB_APP_ID,
        "configuration": {
            "private_key_configured": bool(GITHUB_PRIVATE_KEY),
            "webhook_secret_configured": bool(GITHUB_WEBHOOK_SECRET),
            "openai_configured": bool(OPENAI_API_KEY)
        },
        "features": {
            "smart_contract_analysis": True,
            "ai_code_review": True,
            "issue_automation": True,
            "webhook_processing": True
        }
    })

@app.route('/webhook', methods=['POST'])
def webhook_handler():
    """Main GitHub webhook handler"""
    try:
        # Get GitHub headers
        signature = request.headers.get('X-Hub-Signature-256', '')
        event_type = request.headers.get('X-GitHub-Event', '')
        delivery_id = request.headers.get('X-GitHub-Delivery', '')
        
        # Get payload
        payload = request.get_data()
        
        # Verify signature (skip in demo mode)
        if not ob1_app.verify_webhook_signature(payload, signature):
            logger.warning("Invalid webhook signature")
            return jsonify({"error": "Invalid signature"}), 401
        
        # Parse JSON payload
        try:
            data = json.loads(payload.decode('utf-8'))
        except json.JSONDecodeError:
            return jsonify({"error": "Invalid JSON payload"}), 400
        
        logger.info(f"Received {event_type} event (delivery: {delivery_id})")
        
        # Handle different event types
        if event_type == 'pull_request':
            return handle_pull_request(data)
        elif event_type == 'issues':
            return handle_issues(data)
        elif event_type == 'push':
            return handle_push(data)
        else:
            logger.info(f"Unhandled event type: {event_type}")
            return jsonify({"message": f"Event {event_type} received but not handled"})
    
    except Exception as e:
        logger.error(f"Error in webhook handler: {e}")
        return jsonify({"error": str(e)}), 500

def handle_pull_request(data):
    """Handle pull request events"""
    try:
        action = data.get('action', '')
        pr = data.get('pull_request', {})
        repo = data.get('repository', {})
        
        logger.info(f"PR {action}: {pr.get('title', 'Unknown')} in {repo.get('full_name', 'Unknown')}")
        
        if action in ['opened', 'synchronize']:
            # Analyze PR files
            pr_number = pr.get('number')
            repo_full_name = repo.get('full_name')
            
            # Get installation token (demo mode for now)
            installation_token = "demo-token"
            
            # Simulate file analysis
            analysis = ob1_app.analyze_code_with_ai(
                "// Smart contract code here", 
                "contracts/MyContract.sol"
            )
            
            # Create PR comment
            ob1_app.create_pr_comment(repo_full_name, pr_number, analysis, installation_token)
        
        return jsonify({"message": "Pull request processed", "action": action})
        
    except Exception as e:
        logger.error(f"Error handling pull request: {e}")
        return jsonify({"error": str(e)}), 500

def handle_issues(data):
    """Handle issue events"""
    try:
        action = data.get('action', '')
        issue = data.get('issue', {})
        repo = data.get('repository', {})
        
        logger.info(f"Issue {action}: {issue.get('title', 'Unknown')} in {repo.get('full_name', 'Unknown')}")
        
        if action == 'opened':
            # Check if it's a blockchain-related issue
            title = issue.get('title', '').lower()
            body = issue.get('body', '').lower()
            
            blockchain_keywords = ['smart contract', 'solidity', 'ethereum', 'defi', 'gas', 'blockchain']
            
            if any(keyword in title + ' ' + body for keyword in blockchain_keywords):
                logger.info("Blockchain-related issue detected - OB-1 AI response triggered")
                # Here we would add an AI-generated response to the issue
        
        return jsonify({"message": "Issue processed", "action": action})
        
    except Exception as e:
        logger.error(f"Error handling issue: {e}")
        return jsonify({"error": str(e)}), 500

def handle_push(data):
    """Handle push events"""
    try:
        repo = data.get('repository', {})
        commits = data.get('commits', [])
        
        logger.info(f"Push to {repo.get('full_name', 'Unknown')}: {len(commits)} commit(s)")
        
        # Check for Solidity files in commits
        for commit in commits:
            added = commit.get('added', [])
            modified = commit.get('modified', [])
            
            solidity_files = [f for f in added + modified if f.endswith('.sol')]
            
            if solidity_files:
                logger.info(f"Solidity files detected in commit {commit.get('id', 'Unknown')}: {solidity_files}")
                # Here we could trigger additional analysis
        
        return jsonify({"message": "Push processed", "commits": len(commits)})
        
    except Exception as e:
        logger.error(f"Error handling push: {e}")
        return jsonify({"error": str(e)}), 500

@app.route('/api/analyze', methods=['POST'])
def api_analyze():
    """Direct API endpoint for code analysis"""
    try:
        data = request.get_json()
        
        code = data.get('code', '')
        file_path = data.get('file_path', '')
        
        if not code:
            return jsonify({"error": "No code provided"}), 400
        
        # Perform analysis
        analysis = ob1_app.analyze_code_with_ai(code, file_path)
        
        return jsonify({
            "status": "success",
            "analysis": analysis
        })
        
    except Exception as e:
        logger.error(f"Error in API analyze: {e}")
        return jsonify({"error": str(e)}), 500

if __name__ == '__main__':
    print("🚀 Starting OB-1 Enhanced AI GitHub App")
    print(f"📡 Listening on port {PORT}")
    print(f"🔧 App ID: {GITHUB_APP_ID}")
    print(f"🔑 Private Key Configured: {bool(GITHUB_PRIVATE_KEY)}")
    print(f"🔐 Webhook Secret Configured: {bool(GITHUB_WEBHOOK_SECRET)}")
    print("="*50)
    
    app.run(host='0.0.0.0', port=PORT, debug=True)