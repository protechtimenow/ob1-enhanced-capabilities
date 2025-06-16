# 🚀 OB-1 Enhanced Capabilities - Complete Usage Guide

## Executive Summary
This guide provides comprehensive instructions for setting up, configuring, and running the OB-1 Enhanced AI Capabilities platform, including troubleshooting and deployment options.

---

## 🔧 **Fixed Issues & What Was Missing**

### ✅ **Problems Resolved:**
1. **Missing `__init__.py` files** - Added to all Python modules
2. **Import path issues** - Fixed Python path configuration  
3. **Environment setup** - Created comprehensive setup scripts
4. **Dependencies** - Verified all required packages

### ✅ **New Files Added:**
- `ai_engines/__init__.py` - Engine registry and factory functions
- `commands/__init__.py` - Command registry and execution framework
- `utils/__init__.py` - Utility module initialization
- `setup.py` - Comprehensive setup script
- `run.py` - Easy-to-use application launcher
- `USAGE_GUIDE.md` - This complete usage guide

---

## 🚀 **Quick Start Instructions**

### **Method 1: Automated Setup (Recommended)**

```bash
# Clone the repository
git clone https://github.com/protechtimenow/ob1-enhanced-capabilities.git
cd ob1-enhanced-capabilities

# Run automated setup
python setup.py

# Configure your environment
cp .env.example .env
# Edit .env file with your API keys

# Start the application
python run.py
```

### **Method 2: Manual Setup**

```bash
# 1. Install dependencies
pip install -r requirements.txt

# 2. Create required directories  
mkdir -p logs data config

# 3. Setup environment
cp .env.example .env
# Edit .env with your credentials

# 4. Start with main.py
python main.py
```

### **Method 3: Docker (Production)**

```bash
# Build container
docker build -t ob1-enhanced .

# Run with environment
docker run -p 5000:5000 \
  -e GITHUB_TOKEN=your_token \
  -e OPENAI_API_KEY=your_key \
  ob1-enhanced
```

---

## ⚙️ **Environment Configuration**

### **Required Environment Variables:**

```bash
# Core Configuration
GITHUB_TOKEN=ghp_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
OPENAI_API_KEY=sk-xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
FLASK_ENV=production
PORT=5000

# Security & Performance  
SECRET_KEY=your_flask_secret_key_here
RATE_LIMIT_PER_MINUTE=60
CORS_ORIGINS=*

# Optional Integrations
GITHUB_WEBHOOK_SECRET=your_webhook_secret
IONET_API_KEY=your_ionet_api_key

# Logging
LOG_LEVEL=INFO
LOG_FILE=logs/ob1-agent.log
```

### **Getting API Keys:**

1. **GitHub Token:** 
   - Go to GitHub Settings → Developer Settings → Personal Access Tokens
   - Create token with `repo`, `webhooks`, and `user` permissions

2. **OpenAI API Key:**
   - Visit https://platform.openai.com/api-keys
   - Create new secret key

---

## 🧪 **Testing Your Installation**

### **Health Check:**
```bash
# Method 1: Use the health check script
python health_check.py

# Method 2: Direct curl
curl http://localhost:5000/health

# Method 3: Browser
open http://localhost:5000/health
```

### **Test AI Commands:**
```python
import requests

# Test OB-1 analysis
response = requests.post('http://localhost:5000/ai-command', json={
    "action": "analyze_text",
    "params": {
        "text": "Smart contract deployed at 0x123...",
        "engine": "ob1"
    },
    "user_wallet": "0x21cC30462B8392Aa250453704019800092a16165"
})

print(response.json())
```

---

## 🎯 **Available Endpoints**

### **1. System Status**
```http
GET /
GET /health
GET /analytics
```

### **2. AI Commands**
```http
POST /ai-command
Content-Type: application/json
X-User-Wallet: 0x...

{
  "action": "analyze_text|suggest_code|create_repository|deploy_code",
  "params": { ... },
  "user_wallet": "0x..."
}
```

### **3. GitHub Integration**
```http
POST /github-webhook
X-GitHub-Event: push
X-Hub-Signature-256: sha256=...
```

---

## 🤖 **AI Engine Usage**

### **OB-1 Engine (Blockchain Analysis):**
```json
{
  "action": "analyze_text",
  "params": {
    "text": "Analyze this DeFi transaction: 0xabc...def",
    "engine": "ob1",
    "context": {
      "analysis_type": "security_audit"
    }
  }
}
```

### **Copilot Engine (Code Generation):**
```json
{
  "action": "suggest_code",
  "params": {
    "prompt": "Create an ERC-20 token contract with burn functionality",
    "engine": "copilot",
    "file_path": "contracts/Token.sol"
  }
}
```

### **Engine Switching:**
```json
{
  "action": "switch_engine",
  "params": {
    "target_engine": "r2d2"
  }
}
```

---

## 📊 **Repository Commands**

### **Create Repository:**
```json
{
  "action": "create_repository",
  "params": {
    "name": "my-defi-protocol",
    "description": "AI-generated DeFi protocol",
    "private": false,
    "auto_init": true
  },
  "user_wallet": "0x..."
}
```

### **Deploy Code:**
```json
{
  "action": "deploy_code",
  "params": {
    "repository": "username/repo-name",
    "branch": "main",
    "deployment_target": "io_net"
  }
}
```

### **Analyze Repository:**
```json
{
  "action": "analyze_repository",
  "params": {
    "repository_url": "https://github.com/user/repo",
    "analysis_depth": "full"
  }
}
```

---

## 🐛 **Troubleshooting**

### **Common Issues & Fixes:**

#### **Import Errors:**
```bash
# Error: ModuleNotFoundError: No module named 'utils'
# Fix: Run setup with proper Python path
python setup.py
export PYTHONPATH=$(pwd)
python run.py
```

#### **Missing Dependencies:**
```bash
# Error: ModuleNotFoundError: No module named 'flask'
# Fix: Install dependencies
pip install -r requirements.txt
```

#### **Environment Issues:**
```bash
# Error: Missing GITHUB_TOKEN
# Fix: Check your .env file
cp .env.example .env
# Edit .env and add your tokens
```

#### **Port Already in Use:**
```bash
# Error: Port 5000 is already in use
# Fix: Change port in .env
echo "PORT=5001" >> .env
```

#### **Docker Issues:**
```bash
# Build with no cache
docker build --no-cache -t ob1-enhanced .

# Check logs
docker logs container_name

# Run with debug
docker run -it ob1-enhanced /bin/bash
```

---

## 🔍 **Logs & Debugging**

### **Log Locations:**
- Application logs: `logs/ob1-agent.log`
- Error logs: `logs/error.log`
- Access logs: `logs/access.log`

### **Debug Mode:**
```bash
# Enable debug logging
export FLASK_ENV=development
export LOG_LEVEL=DEBUG
python run.py
```

### **Monitoring:**
```bash
# Watch logs in real-time
tail -f logs/ob1-agent.log

# Check system resources
top -p $(pgrep -f "python.*main.py")
```

---

## 🚀 **Deployment Options**

### **1. Local Development:**
- Use `python run.py` for quick testing
- Enables hot reload and debug mode
- Best for development and testing

### **2. Production Server:**
- Use Gunicorn: `gunicorn --bind 0.0.0.0:5000 main:app`
- Configure reverse proxy (nginx)
- Set up SSL certificates

### **3. Docker Deployment:**
- Production-ready container
- Includes all dependencies
- Easy scaling and orchestration

### **4. IO.NET Container Engine:**
- Optimized for cloud deployment
- Auto-scaling capabilities
- Built-in monitoring and health checks

---

## 📈 **Performance Optimization**

### **Resource Usage:**
- **RAM:** ~512MB baseline, ~2GB under load
- **CPU:** 1-2 cores recommended
- **Disk:** 10GB minimum for logs and data
- **Network:** HTTP/HTTPS on configurable port

### **Scaling:**
- Increase worker processes in gunicorn
- Use Redis for session storage
- Implement load balancing
- Set up database clustering

---

## 🔐 **Security Best Practices**

1. **Environment Security:**
   - Never commit `.env` files
   - Use strong secret keys
   - Rotate API keys regularly

2. **Network Security:**
   - Use HTTPS in production
   - Configure proper CORS settings
   - Implement rate limiting

3. **Application Security:**
   - Validate all inputs
   - Sanitize user data
   - Monitor for suspicious activity

---

## 💡 **Advanced Usage**

### **Custom Engine Integration:**
```python
# Add custom engine in ai_engines/
from .custom_engine import CustomEngine

# Register in ai_engines/__init__.py
ENGINE_REGISTRY['custom'] = CustomEngine
```

### **Webhook Configuration:**
```bash
# Set up GitHub webhook
curl -X POST https://api.github.com/repos/user/repo/hooks \
  -H "Authorization: token $GITHUB_TOKEN" \
  -d '{
    "name": "web",
    "config": {
      "url": "https://your-domain.com/github-webhook",
      "content_type": "json"
    }
  }'
```

### **Analytics Integration:**
```python
# Custom analytics endpoint
@app.route('/custom-analytics')
def custom_analytics():
    from utils.persistence import get_user_analytics
    return jsonify(get_user_analytics(user_wallet))
```

---

## 📞 **Support & Resources**

- **GitHub Issues:** Report bugs and feature requests
- **Documentation:** Complete API reference
- **Community:** Discord server for discussions
- **Updates:** Follow the repository for latest changes

**🎉 Your OB-1 Enhanced Capabilities platform is now ready for use!**