# 🚀 OB-1 Enhanced Capabilities

> **AI-powered orchestration service for autonomous GitHub operations and blockchain analysis**

[![Docker Build](https://img.shields.io/badge/docker-ready-brightgreen)](./Dockerfile)
[![Python 3.11](https://img.shields.io/badge/python-3.11-blue.svg)](https://www.python.org/)
[![IO.NET Compatible](https://img.shields.io/badge/IO.NET-compatible-orange)](https://io.net)
[![Flask](https://img.shields.io/badge/flask-2.3.3-lightgrey)](https://flask.palletsprojects.com/)

## 🤖 **About OB-1 Enhanced**

OB-1 Enhanced is a multi-engine AI orchestration platform that combines:

- **🧠 OB-1 Core**: Blockchain & DeFi analysis engine
- **⚡ Copilot Integration**: Code generation and development assistance 
- **🔮 R2D2 (Coming Soon)**: Advanced reasoning and multi-modal analysis

**Key Capabilities:**
- Autonomous GitHub repository management
- AI-powered code analysis and generation
- Blockchain transaction analysis
- DeFi protocol security auditing
- Real-time webhook processing
- Multi-engine load balancing

---

## 🚀 **Quick Start**

### **Option 1: Docker Deployment (Recommended)**
```bash
# Clone the repository
git clone https://github.com/protechtimenow/ob1-enhanced-capabilities.git
cd ob1-enhanced-capabilities

# Build and run with Docker
docker build -t ob1-enhanced .
docker run -p 5000:5000 -e GITHUB_TOKEN=your_token ob1-enhanced
```

### **Option 2: Local Development**
```bash
# Install dependencies
pip install -r requirements.txt

# Set environment variables
cp .env.example .env
# Edit .env with your configurations

# Run the application
python main.py
```

### **Option 3: IO.NET Container Engine**
```bash
# Deploy to IO.NET (requires IO.NET CLI)
io deploy --config config.yaml --image ob1-enhanced
```

---

## 🔧 **API Endpoints**

### **🏠 Health & Status**
```http
GET /health
```
Returns system health and engine status.

### **🤖 AI Command Interface**
```http
POST /ai-command
Content-Type: application/json

{
  "action": "analyze_text",
  "params": {
    "text": "Analyze this smart contract vulnerability",
    "engine": "ob1"
  },
  "user_wallet": "0x..."
}
```

**Available Actions:**
- `analyze_text` - Multi-engine text analysis
- `suggest_code` - AI code generation
- `create_repository` - GitHub repo creation
- `deploy_code` - Automated code deployment
- `analyze_repository` - Repo security & quality analysis
- `switch_engine` - Engine switching

### **📡 GitHub Webhook Handler**
```http
POST /github-webhook
X-GitHub-Event: push
Content-Type: application/json

{
  "commits": [...],
  "repository": {...}
}
```

### **📊 Analytics Dashboard**
```http
GET /analytics
X-User-Wallet: 0x...
```

---

## 🧠 **AI Engine Capabilities**

| Engine | Status | Specialization | Use Cases |
|--------|--------|---------------|----------|
| **OB-1** | ✅ Active | Blockchain & DeFi | Smart contract analysis, DeFi protocol auditing, transaction analysis |
| **Copilot** | ✅ Active | Code Development | Code generation, refactoring, CLI integration |
| **R2D2** | 🚧 Coming Soon | Advanced Reasoning | Multi-modal analysis, predictive modeling, autonomous decisions |

---

## ⚙️ **Configuration**

### **Environment Variables**
```bash
# Required
GITHUB_TOKEN=ghp_xxxxxxxxxxxx
FLASK_ENV=production
PORT=5000

# Optional
GITHUB_WEBHOOK_SECRET=your_secret
OPENAI_API_KEY=sk-xxxxxxxx
RATE_LIMIT_PER_MINUTE=60
LOG_LEVEL=INFO
```

### **config.yaml**
```yaml
ai_engines:
  ob1:
    enabled: true
    priority: 1
  copilot:
    enabled: true
    priority: 2
  r2d2:
    enabled: false
    priority: 3

server:
  host: "0.0.0.0"
  port: 5000
  workers: 2
```

---

## 🧪 **Example Usage**

### **1. Blockchain Analysis**
```python
import requests

response = requests.post('http://localhost:5000/ai-command', json={
    "action": "analyze_text",
    "params": {
        "text": "0x1234...abcd sent 100 ETH to Uniswap V3 pool",
        "engine": "ob1"
    }
})

print(response.json())
# {
#   "analysis_type": "blockchain_analysis",
#   "detected_entities": {
#     "addresses": ["0x1234...abcd"],
#     "protocols": ["Uniswap V3"]
#   },
#   "risk_assessment": "low"
# }
```

### **2. Code Generation**
```python
response = requests.post('http://localhost:5000/ai-command', json={
    "action": "suggest_code",
    "params": {
        "prompt": "Create a Python function to validate Ethereum addresses",
        "engine": "copilot"
    }
})
```

### **3. Repository Creation**
```python
response = requests.post('http://localhost:5000/ai-command', json={
    "action": "create_repository",
    "params": {
        "name": "my-defi-project",
        "description": "AI-generated DeFi protocol",
        "private": false
    },
    "user_wallet": "0x..."
})
```

---

## 📊 **Performance Metrics**

- **Response Time**: < 500ms average
- **Uptime**: 99.9% target
- **Concurrent Users**: 1000+
- **Request Rate**: 60 requests/minute per user
- **Memory Usage**: ~512MB baseline

---

## 🔒 **Security Features**

- **🛡️ Rate Limiting**: 60 requests/minute per user
- **🔐 Input Validation**: All inputs sanitized and validated
- **📝 Audit Logging**: Complete activity tracking
- **🚫 CORS Protection**: Configurable origin restrictions
- **👤 User Isolation**: Wallet-based session management
- **🔄 Auto-Updates**: Security patches applied automatically

---

## 🎯 **IO.NET Deployment**

### **Compute Requirements**
- **CPU**: 2 cores
- **Memory**: 4GB RAM
- **Storage**: 10GB
- **Network**: HTTP/HTTPS traffic

### **Health Checks**
- **Endpoint**: `/health`
- **Interval**: 30s
- **Timeout**: 10s
- **Retries**: 3

---

## 📈 **Roadmap**

### **Phase 1 (Current)** ✅ 
- Multi-engine AI orchestration
- GitHub integration
- Basic analytics

### **Phase 2 (Q2 2024)** 🚧
- R2D2 engine integration
- Advanced reasoning capabilities
- Multi-modal analysis

### **Phase 3 (Q3 2024)** 📋
- Autonomous agent workflows
- Cross-protocol DeFi analysis
- Real-time threat detection

---

## 🤝 **Contributing**

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

---

## 📄 **License**

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## 🆘 **Support**

- **GitHub Issues**: [Create an issue](https://github.com/protechtimenow/ob1-enhanced-capabilities/issues)
- **Discord**: [Join our community](https://discord.gg/ob1-ai)
- **Documentation**: [Full docs](https://docs.ob1.ai)

---

**🚀 Powered by IO.NET Container Engine | Built with ❤️ by the OB-1 Team**