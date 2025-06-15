# 🚀 IO.NET Quick Deploy Guide

> Deploy OB-1 Enhanced to IO.NET Container Engine in 5 minutes

## 📋 Prerequisites

1. **IO.NET Account**: Sign up at [io.net](https://io.net)
2. **GitHub Token**: Personal access token with repo permissions
3. **Docker**: Local Docker installation (optional, for testing)

---

## ⚡ Quick Deploy Steps

### **Step 1: Prepare Secrets**
In your IO.NET dashboard, create these secrets:

```yaml
Secrets:
  - name: github-token
    value: "ghp_XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
  - name: webhook-secret  # Optional
    value: "your-webhook-secret-here"
```

### **Step 2: Deploy Configuration**
Use the provided `io-net-deploy.yaml` configuration:

```bash
# Option A: Deploy via IO.NET CLI
io deploy --config io-net-deploy.yaml

# Option B: Deploy via Dashboard
# Upload io-net-deploy.yaml to your IO.NET project dashboard
```

### **Step 3: Verify Deployment**
Once deployed, check these endpoints:

```bash
# Health check
curl https://your-app.ionet.ai/health

# Expected response:
{
  "status": "healthy",
  "engines": {
    "ob1": "active",
    "copilot": "active"
  },
  "uptime": "00:01:23"
}
```

---

## 🔧 Configuration Details

### **Resource Allocation**
```yaml
Resources:
  CPU: 1-2 cores
  Memory: 2-4GB
  Storage: 5-10GB
  Network: HTTP/HTTPS + Webhooks
```

### **Environment Variables**
```yaml
Environment:
  FLASK_ENV: production
  PORT: 5000
  WORKERS: 2
  GITHUB_TOKEN: <from-secrets>
  GITHUB_WEBHOOK_SECRET: <from-secrets>
```

### **Health Checks**
```yaml
Health Checks:
  Endpoint: /health
  Initial Delay: 30s
  Check Interval: 30s
  Timeout: 10s
  Failure Threshold: 3
```

---

## 🎯 Testing Your Deployment

### **1. Test AI Command Interface**
```bash
curl -X POST https://your-app.ionet.ai/ai-command \
  -H "Content-Type: application/json" \
  -d '{
    "action": "analyze_text",
    "params": {
      "text": "Test blockchain analysis",
      "engine": "ob1"
    }
  }'
```

### **2. Test GitHub Webhook** 
```bash
curl -X POST https://your-app.ionet.ai/github-webhook \
  -H "Content-Type: application/json" \
  -H "X-GitHub-Event: ping" \
  -d '{"zen": "Design for failure."}'
```

### **3. Test Analytics Dashboard**
```bash
curl https://your-app.ionet.ai/analytics \
  -H "X-User-Wallet: 0x21cC30462B8392Aa250453704019800092a16165"
```

---

## 🔄 Auto-Scaling Configuration

The deployment includes automatic scaling based on:

```yaml
Auto-Scaling:
  Min Replicas: 1
  Max Replicas: 3
  CPU Target: 70%
  Memory Target: 80%
  Scale-up Delay: 30s
  Scale-down Delay: 300s
```

---

## 📊 Monitoring & Logs

### **Real-time Monitoring**
- **Health**: `GET /health`
- **Metrics**: Built-in Flask metrics
- **User Analytics**: `/analytics` endpoint

### **Log Access**
```bash
# Via IO.NET CLI
io logs --app ob1-enhanced-capabilities --lines 100

# Via Dashboard
# Navigate to your app → Logs tab
```

### **Key Metrics to Monitor**
- **Response Time**: < 500ms target
- **Memory Usage**: < 3GB sustained
- **CPU Usage**: < 70% sustained  
- **Request Rate**: < 60/min per user
- **Error Rate**: < 1%

---

## 🛡️ Security Features

### **Built-in Security**
- **Rate Limiting**: 60 requests/minute per user
- **Input Validation**: All inputs sanitized
- **CORS Protection**: Configurable origins
- **SSL/TLS**: Automatic certificate management
- **Non-root Container**: Security hardened

### **Secrets Management**
- **GitHub Token**: Stored in IO.NET secrets
- **Webhook Secret**: Optional GitHub webhook verification
- **Environment Isolation**: Production-grade separation

---

## 🚨 Troubleshooting

### **Common Issues**

**❌ Deployment Failed**
```bash
# Check logs
io logs --app ob1-enhanced-capabilities

# Common fixes:
# 1. Verify secrets are configured
# 2. Check resource limits
# 3. Validate YAML syntax
```

**❌ Health Check Failing**
```bash
# Test locally first
curl http://localhost:5000/health

# Check environment variables
io env --app ob1-enhanced-capabilities
```

**❌ GitHub Integration Issues**
```bash
# Verify token permissions
curl -H "Authorization: token $GITHUB_TOKEN" \
  https://api.github.com/user

# Check webhook delivery
# GitHub repo → Settings → Webhooks
```

### **Performance Optimization**

**For High Traffic:**
```yaml
# Update io-net-deploy.yaml
resources:
  limits:
    cpu: "4000m"    # 4 cores
    memory: "8Gi"   # 8GB RAM

autoScaling:
  maxReplicas: 5
  targetCPUUtilizationPercentage: 50
```

**For Cost Optimization:**
```yaml
# Reduce resources
resources:
  requests:
    cpu: "500m"     # 0.5 cores
    memory: "1Gi"   # 1GB RAM
  limits:
    cpu: "1000m"    # 1 core
    memory: "2Gi"   # 2GB RAM
```

---

## 📈 Scaling Your Deployment

### **Horizontal Scaling**
```bash
# Scale replicas manually
io scale --app ob1-enhanced-capabilities --replicas 3

# Auto-scaling is configured in YAML
```

### **Vertical Scaling** 
```bash
# Update resource limits
io update --app ob1-enhanced-capabilities \
  --cpu-limit 4000m --memory-limit 8Gi
```

---

## 🎯 Next Steps

Once deployed, you can:

1. **🔗 Connect GitHub Webhooks**
   - Add your IO.NET URL to GitHub repo webhooks
   - Test with push events and issues

2. **🤖 Integrate AI Commands**
   - Use `/ai-command` endpoint in your applications
   - Switch between OB-1 and Copilot engines

3. **📊 Monitor Performance**
   - Set up alerts for health checks
   - Track user analytics and usage patterns

4. **🚀 Scale Operations**
   - Add more GitHub repos to webhook
   - Increase resource limits for higher traffic
   - Deploy multiple instances for redundancy

---

## 🆘 Support

- **📖 Documentation**: [Full deployment guide](README.md)
- **🐛 Issues**: [GitHub Issues](https://github.com/protechtimenow/ob1-enhanced-capabilities/issues)
- **💬 Community**: [Discord Server](https://discord.gg/ob1-ai)
- **📧 Direct Support**: support@ob1.ai

---

**🚀 Ready to deploy? Run `io deploy --config io-net-deploy.yaml` and you're live in minutes!**