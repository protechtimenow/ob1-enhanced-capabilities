#!/usr/bin/env python3
"""
OB-1 Enhanced Capabilities - GitHub App
A powerful AI-driven GitHub App for blockchain development
"""

import os
import hmac
import hashlib
import jwt
from datetime import datetime, timedelta
from flask import Flask, request, jsonify, render_template_string
from github import Github
from ai_engines.ob1 import OB1Engine
from ai_engines.copilot import CopilotEngine
from ai_engines.r2d2 import R2D2Engine
from utils.blockchain_analyzer import BlockchainAnalyzer
from utils.logger import setup_logger

# Initialize Flask app
app = Flask(__name__)
logger = setup_logger('github_app')

# GitHub App Configuration
GITHUB_APP_ID = os.getenv('GITHUB_APP_ID')
GITHUB_PRIVATE_KEY = os.getenv('GITHUB_PRIVATE_KEY')
GITHUB_WEBHOOK_SECRET = os.getenv('GITHUB_WEBHOOK_SECRET')

class OB1GitHubApp:
    """OB-1 Enhanced Capabilities GitHub App"""
    
    def __init__(self):
        self.ai_engines = {
            'ob1': OB1Engine(),
            'copilot': CopilotEngine(),
            'r2d2': R2D2Engine()
        }
        self.blockchain_analyzer = BlockchainAnalyzer()
    
    def get_github_client(self, installation_id):
        """Get authenticated GitHub client for installation"""
        # Generate JWT for app authentication
        payload = {
            'iat': datetime.utcnow(),
            'exp': datetime.utcnow() + timedelta(minutes=10),
            'iss': GITHUB_APP_ID
        }
        
        jwt_token = jwt.encode(payload, GITHUB_PRIVATE_KEY, algorithm='RS256')
        
        # Get installation access token
        import requests
        headers = {
            'Authorization': f'Bearer {jwt_token}',
            'Accept': 'application/vnd.github.v3+json'
        }
        
        response = requests.post(
            f'https://api.github.com/app/installations/{installation_id}/access_tokens',
            headers=headers
        )
        
        access_token = response.json()['token']
        return Github(access_token)
    
    def verify_webhook_signature(self, payload_body, signature_header):
        """Verify GitHub webhook signature"""
        if not signature_header:
            return False
            
        sha_name, signature = signature_header.split('=')
        if sha_name != 'sha256':
            return False
            
        mac = hmac.new(
            GITHUB_WEBHOOK_SECRET.encode('utf-8'),
            payload_body,
            digestmod=hashlib.sha256
        )
        
        return hmac.compare_digest(mac.hexdigest(), signature)
    
    def analyze_smart_contract(self, contract_address, chain='ethereum'):
        """Analyze smart contract using OB-1 AI"""
        try:
            analysis = self.blockchain_analyzer.analyze_contract(
                contract_address, 
                chain,
                ai_engine='ob1'
            )
            return {
                'success': True,
                'analysis': analysis,
                'recommendations': self.generate_recommendations(analysis)
            }
        except Exception as e:
            logger.error(f"Contract analysis failed: {e}")
            return {
                'success': False,
                'error': str(e)
            }
    
    def generate_recommendations(self, analysis):
        """Generate AI-powered recommendations"""
        return self.ai_engines['ob1'].generate_recommendations(analysis)

# Initialize OB-1 GitHub App
ob1_app = OB1GitHubApp()

@app.route('/')
def home():
    """GitHub App home page"""
    return render_template_string("""
    <!DOCTYPE html>
    <html>
    <head>
        <title>OB-1 Enhanced AI Capabilities</title>
        <style>
            body { font-family: -apple-system, BlinkMacSystemFont, Segoe UI, Roboto, sans-serif; margin: 40px; }
            .header { text-align: center; margin-bottom: 40px; }
            .feature { margin: 20px 0; padding: 20px; border: 1px solid #e1e4e8; border-radius: 8px; }
            .install-btn { background: #1976d2; color: white; padding: 12px 24px; text-decoration: none; border-radius: 6px; }
        </style>
    </head>
    <body>
        <div class="header">
            <h1>🤖 OB-1 Enhanced AI Capabilities</h1>
            <p>Powerful AI-driven blockchain development assistant for GitHub</p>
            <a href="/install" class="install-btn">Install GitHub App</a>
        </div>
        
        <div class="feature">
            <h3>🔗 Smart Contract Analysis</h3>
            <p>AI-powered analysis of Solidity contracts with security recommendations</p>
        </div>
        
        <div class="feature">
            <h3>🔍 Code Review Assistant</h3>
            <p>Automated code review with blockchain best practices</p>
        </div>
        
        <div class="feature">
            <h3>📊 DeFi Analytics</h3>
            <p>Real-time analysis of DeFi protocols and market data</p>
        </div>
        
        <div class="feature">
            <h3>🤝 Multi-AI Integration</h3>
            <p>Combines OB-1, GitHub Copilot, and R2D2 AI engines</p>
        </div>
    </body>
    </html>
    """)

@app.route('/install')
def install():
    """GitHub App installation page"""
    github_app_url = f"https://github.com/apps/ob1-enhanced-capabilities"
    return f'<script>window.location.href = "{github_app_url}";</script>'

@app.route('/webhook', methods=['POST'])
def github_webhook():
    """Handle GitHub webhook events"""
    # Verify webhook signature
    if not ob1_app.verify_webhook_signature(request.data, request.headers.get('X-Hub-Signature-256')):
        return jsonify({'error': 'Invalid signature'}), 403
    
    event_type = request.headers.get('X-GitHub-Event')
    payload = request.json
    
    logger.info(f"Received {event_type} event")
    
    try:
        if event_type == 'issues':
            return handle_issues_event(payload)
        elif event_type == 'pull_request':
            return handle_pull_request_event(payload)
        elif event_type == 'push':
            return handle_push_event(payload)
        elif event_type == 'installation':
            return handle_installation_event(payload)
        else:
            return jsonify({'status': 'event_not_handled'})
    
    except Exception as e:
        logger.error(f"Webhook error: {e}")
        return jsonify({'error': str(e)}), 500

def handle_issues_event(payload):
    """Handle GitHub issues events"""
    action = payload['action']
    issue = payload['issue']
    installation_id = payload['installation']['id']
    
    if action == 'opened':
        # Check if issue mentions smart contract analysis
        if 'contract' in issue['title'].lower() or 'analyze' in issue['title'].lower():
            github_client = ob1_app.get_github_client(installation_id)
            repo = github_client.get_repo(payload['repository']['full_name'])
            
            # AI-powered issue analysis
            ai_response = ob1_app.ai_engines['ob1'].analyze_issue(issue['body'])
            
            # Add AI comment to issue
            comment = f"""
## 🤖 OB-1 AI Analysis

{ai_response}

---
*Powered by OB-1 Enhanced AI Capabilities*
            """
            
            repo.get_issue(issue['number']).create_comment(comment)
    
    return jsonify({'status': 'processed'})

def handle_pull_request_event(payload):
    """Handle GitHub pull request events"""
    action = payload['action']
    pr = payload['pull_request']
    installation_id = payload['installation']['id']
    
    if action == 'opened':
        github_client = ob1_app.get_github_client(installation_id)
        repo = github_client.get_repo(payload['repository']['full_name'])
        
        # Get PR files
        pr_obj = repo.get_pull(pr['number'])
        files = pr_obj.get_files()
        
        # Analyze Solidity files
        for file in files:
            if file.filename.endswith('.sol'):
                # AI-powered Solidity analysis
                analysis = ob1_app.ai_engines['ob1'].analyze_solidity_code(file.patch)
                
                if analysis.get('issues'):
                    comment = f"""
## 🔍 Smart Contract Analysis - `{file.filename}`

{analysis['summary']}

### Issues Found:
{chr(10).join(f"- {issue}" for issue in analysis['issues'])}

### Recommendations:
{chr(10).join(f"- {rec}" for rec in analysis['recommendations'])}

---
*Automated analysis by OB-1 Enhanced AI*
                    """
                    
                    pr_obj.create_issue_comment(comment)
    
    return jsonify({'status': 'processed'})

def handle_push_event(payload):
    """Handle GitHub push events"""
    # Analyze commits for smart contract changes
    commits = payload['commits']
    installation_id = payload['installation']['id']
    
    for commit in commits:
        if any('.sol' in file for file in commit.get('added', []) + commit.get('modified', [])):
            logger.info(f"Smart contract changes detected in commit {commit['id']}")
            # Add deployment analysis, security checks, etc.
    
    return jsonify({'status': 'processed'})

def handle_installation_event(payload):
    """Handle GitHub app installation events"""
    action = payload['action']
    installation = payload['installation']
    
    if action == 'created':
        logger.info(f"OB-1 installed for {installation['account']['login']}")
        
        # Send welcome message or setup repositories
        github_client = ob1_app.get_github_client(installation['id'])
        
        # You could create initial issues, set up webhooks, etc.
    
    return jsonify({'status': 'installation_processed'})

@app.route('/api/analyze-contract', methods=['POST'])
def api_analyze_contract():
    """API endpoint for smart contract analysis"""
    data = request.json
    contract_address = data.get('contract_address')
    chain = data.get('chain', 'ethereum')
    
    if not contract_address:
        return jsonify({'error': 'contract_address required'}), 400
    
    result = ob1_app.analyze_smart_contract(contract_address, chain)
    return jsonify(result)

@app.route('/health')
def health():
    """Health check endpoint"""
    return jsonify({
        'status': 'healthy',
        'app': 'ob1-enhanced-capabilities',
        'version': '1.0.0',
        'ai_engines': list(ob1_app.ai_engines.keys()),
        'timestamp': datetime.utcnow().isoformat()
    })

if __name__ == '__main__':
    port = int(os.getenv('PORT', 5000))
    app.run(host='0.0.0.0', port=port, debug=False)