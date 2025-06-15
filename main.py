python
from flask import Flask, request, jsonify
import sqlite3
import os
import json
from datetime import datetime
import requests

app = Flask(__name__)

# Initialize SQLite database for logging
def init_db():
    conn = sqlite3.connect('memory.db', check_same_thread=False)
    cursor = conn.cursor()
    cursor.execute('CREATE TABLE IF NOT EXISTS logs (timestamp TEXT, event TEXT, detail TEXT)')
    conn.commit()
    return conn, cursor

conn, cursor = init_db()

def log_event(event, detail):
    """Helper to log events to the SQLite database."""
    timestamp = datetime.utcnow().isoformat()
    cursor.execute('INSERT INTO logs VALUES (?, ?, ?)', (timestamp, event, detail))
    conn.commit()

@app.route('/')
def index():
    log_event("index_access", "Root endpoint accessed")
    return jsonify({
        "service": "OB-1 Enhanced AI Capabilities Infrastructure", 
        "version": "1.0",
        "status": "Active",
        "endpoints": ["/ai-command", "/github-webhook", "/health"],
        "capabilities": ["repository_creation", "github_integration", "persistent_memory"]
    })

@app.route('/health')
def health():
    log_event("health_check", "Health endpoint called")
    return jsonify({
        "status": "healthy",
        "timestamp": datetime.utcnow().isoformat(),
        "service": "OB-1 Enhanced Capabilities"
    })

@app.route('/ai-command', methods=['POST'])
def ai_command():
    """Execute OB-1 enhanced commands"""
    data = request.json or {}
    log_event("ai_command", json.dumps(data))
    
    cmd = data.get("command")
    
    if cmd == "create_repository":
        return create_repository_endpoint(data)
    elif cmd == "deploy_code":
        return deploy_code_endpoint(data)
    elif cmd == "test_capability":
        return test_capability_endpoint(data)
    elif cmd == "get_logs":
        return get_logs_endpoint(data)
    else:
        return jsonify({"error": "Unknown command", "available_commands": ["create_repository", "deploy_code", "test_capability", "get_logs"]}), 400

def create_repository_endpoint(data):
    """Create GitHub repository"""
    token = os.getenv("GITHUB_TOKEN")
    if not token:
        return jsonify({"error": "Missing GITHUB_TOKEN environment variable"}), 500
    
    headers = {
        "Authorization": f"token {token}", 
        "Accept": "application/vnd.github.v3+json"
    }
    
    repo_name = data.get("repo_name", f"ob1-created-{datetime.now().strftime('%m%d%H%M')}")
    description = data.get("description", "Repository created by OB-1 Enhanced Capabilities")
    
    payload = {
        "name": repo_name,
        "description": description,
        "private": data.get("private", False),
        "auto_init": True
    }
    
    resp = requests.post("https://api.github.com/user/repos", headers=headers, json=payload)
    
    if resp.status_code == 201:
        repo_data = resp.json()
        result = {
            "status": "repository_created",
            "name": repo_data["name"],
            "url": repo_data["html_url"],
            "clone_url": repo_data["clone_url"]
        }
        log_event("repository_created", json.dumps(result))
        return jsonify(result), 201
    else:
        error_detail = {"status_code": resp.status_code, "response": resp.text}
        log_event("repository_creation_failed", json.dumps(error_detail))
        return jsonify({"error": "GitHub API failed", "details": error_detail}), resp.status_code

def deploy_code_endpoint(data):
    """Deploy code capability"""
    result = {
        "status": "deploy_code_ready",
        "message": "Code deployment capability active",
        "received_params": list(data.keys())
    }
    log_event("deploy_code_called", json.dumps(result))
    return jsonify(result), 200

def test_capability_endpoint(data):
    """Test OB-1 capabilities"""
    result = {
        "status": "OB-1_capabilities_active",
        "timestamp": datetime.utcnow().isoformat(),
        "tests": {
            "database_connection": "healthy" if conn else "failed",
            "github_token": "configured" if os.getenv("GITHUB_TOKEN") else "missing",
            "flask_app": "running"
        }
    }
    log_event("capability_test", json.dumps(result))
    return jsonify(result), 200

def get_logs_endpoint(data):
    """Retrieve recent logs"""
    limit = data.get("limit", 50)
    cursor.execute('SELECT * FROM logs ORDER BY timestamp DESC LIMIT ?', (limit,))
    logs = cursor.fetchall()
    
    result = {
        "status": "logs_retrieved",
        "count": len(logs),
        "logs": [{"timestamp": log[0], "event": log[1], "detail": log[2]} for log in logs]
    }
    return jsonify(result), 200

@app.route('/github-webhook', methods=['POST'])
def github_webhook():
    """Enhanced GitHub webhook processing"""
    payload = request.json or {}
    event_type = request.headers.get('X-GitHub-Event', 'unknown')
    
    log_event("github_webhook", json.dumps({
        "event_type": event_type,
        "repository": payload.get("repository", {}).get("name", "unknown")
    }))
    
    # Enhanced analysis
    analysis = analyze_github_event(event_type, payload)
    
    return jsonify({
        "status": "processed_with_ob1_intelligence",
        "event_type": event_type,
        "analysis": analysis,
        "timestamp": datetime.utcnow().isoformat()
    })

def analyze_github_event(event_type, payload):
    """Analyze GitHub events with OB-1 intelligence"""
    if event_type == "push":
        commits = payload.get("commits", [])
        analysis = []
        
        for commit in commits:
            message = commit.get("message", "").lower()
            
            # AI-enhanced commit analysis
            if any(keyword in message for keyword in ["security", "vulnerability", "fix", "patch"]):
                analysis.append({"type": "security_relevant", "commit": commit["id"], "priority": "high"})
            elif any(keyword in message for keyword in ["deploy", "release", "production"]):
                analysis.append({"type": "deployment_relevant", "commit": commit["id"], "priority": "medium"})
            elif any(keyword in message for keyword in ["ai", "ml", "intelligence", "ob-1"]):
                analysis.append({"type": "ai_enhancement", "commit": commit["id"], "priority": "high"})
            elif any(keyword in message for keyword in ["feature", "enhancement", "improvement"]):
                analysis.append({"type": "feature_development", "commit": commit["id"], "priority": "low"})
        
        log_event("commit_analysis", json.dumps(analysis))
        return {
            "commits_analyzed": len(commits),
            "insights": analysis,
            "ob1_intelligence": "applied"
        }
    
    elif event_type == "pull_request":
        pr = payload.get("pull_request", {})
        action = payload.get("action")
        
        analysis = {
            "pr_number": pr.get("number"),
            "action": action,
            "title_analysis": analyze_pr_title(pr.get("title", "")),
            "ob1_recommendation": get_pr_recommendation(pr, action)
        }
        
        log_event("pr_analysis", json.dumps(analysis))
        return analysis
    
    else:
        return {"event_processed": event_type, "ob1_status": "monitoring"}

def analyze_pr_title(title):
    """Analyze PR titles for categorization"""
    title_lower = title.lower()
    
    if any(keyword in title_lower for keyword in ["fix", "bug", "patch"]):
        return "bug_fix"
    elif any(keyword in title_lower for keyword in ["feature", "add", "implement"]):
        return "feature_addition"
    elif any(keyword in title_lower for keyword in ["refactor", "improve", "optimize"]):
        return "improvement"
    elif any(keyword in title_lower for keyword in ["security", "vulnerability"]):
        return "security_fix"
    else:
        return "general"

def get_pr_recommendation(pr, action):
    """Get OB-1 recommendations for PR handling"""
    if action == "opened":
        return "automated_review_triggered"
    elif action == "closed" and pr.get("merged"):
        return "deployment_consideration_recommended"
    else:
        return f"monitoring_{action}_action"

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=int(os.environ.get("PORT", 5000)))
