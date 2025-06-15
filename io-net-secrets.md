# IO.NET Secret Key Configuration Guide

## 🔐 Secret Key Setup for OB-1 Enhanced Capabilities

This guide walks you through setting up the required secret keys for deploying OB-1 Enhanced Capabilities on IO.NET infrastructure.

### 📋 **Required Secret Keys**

You'll need to create the following secret keys in your IO.NET dashboard:

#### **1. IO Intelligence Project**
```
Name: OB1_GITHUB_TOKEN
Project: IO Intelligence  
Permissions: All
Expiration: 180 days
Value: [Your GitHub Personal Access Token]
```

#### **2. IO Cloud Project**
```
Name: OB1_WEBHOOK_SECRET
Project: IO Cloud
Permissions: All  
Expiration: 180 days
Value: [Random 32-character secret for webhook validation]
```

---

### 🎯 **Step-by-Step Setup**

#### **Step 1: GitHub Token (IO Intelligence)**
1. Go to GitHub → Settings → Developer settings → Personal access tokens
2. Create new token with these permissions:
   - `repo` (Full control of private repositories)
   - `workflow` (Update GitHub Action workflows)
   - `read:org` (Read org and team membership)
3. Copy the token
4. In IO.NET dashboard:
   - Navigate to Secret Keys
   - Click "Create New Secret Key"
   - Name: `OB1_GITHUB_TOKEN`
   - Project: **IO Intelligence**
   - Permissions: **All**
   - Expiration: **180 days**
   - Value: [Paste your GitHub token]

#### **Step 2: Webhook Secret (IO Cloud)**
1. Generate a secure random string (32+ characters):
   ```bash
   openssl rand -hex 32
   ```
   Or use: https://passwordsgenerator.net/
   
2. In IO.NET dashboard:
   - Click "Create New Secret Key"
   - Name: `OB1_WEBHOOK_SECRET`
   - Project: **IO Cloud**
   - Permissions: **All**
   - Expiration: **180 days**
   - Value: [Your generated secret]

#### **Step 3: Optional Additional Secrets**
For enhanced functionality, you may also want to add:

```
Name: OB1_OPENAI_API_KEY
Project: IO Intelligence
Value: [Your OpenAI API key for enhanced AI features]

Name: OB1_ALCHEMY_API_KEY  
Project: IO Cloud
Value: [Your Alchemy API key for blockchain data]
```

---

### 🚀 **Deployment Configuration**

Once secrets are created, update your `io-net-deploy.yaml`:

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: ob1-enhanced
spec:
  template:
    spec:
      containers:
      - name: ob1-enhanced
        image: ob1-enhanced:latest
        env:
        - name: GITHUB_TOKEN
          valueFrom:
            secretKeyRef:
              name: OB1_GITHUB_TOKEN
              key: value
        - name: WEBHOOK_SECRET
          valueFrom:
            secretKeyRef:
              name: OB1_WEBHOOK_SECRET  
              key: value
        - name: FLASK_ENV
          value: "production"
        - name: PORT
          value: "5000"
```

---

### 🔒 **Security Best Practices**

✅ **Token Permissions**: Use minimal required permissions for GitHub tokens
✅ **Secret Rotation**: Rotate secrets every 90 days or when compromised
✅ **Environment Separation**: Use different secrets for dev/staging/production
✅ **Access Control**: Limit secret access to necessary team members only
✅ **Monitoring**: Monitor secret usage and access patterns
✅ **Backup**: Store emergency access codes in secure offline storage

---

### 🧪 **Testing Your Setup**

After deployment, test your configuration:

```bash
# Test health endpoint
curl https://your-deployment-url.io.net/health

# Test AI command endpoint
curl -X POST https://your-deployment-url.io.net/ai-command \
  -H "Content-Type: application/json" \
  -d '{"command": "status", "engine": "ob1"}'

# Test GitHub webhook (replace with your webhook URL)  
curl -X POST https://your-deployment-url.io.net/github-webhook \
  -H "Content-Type: application/json" \
  -H "X-GitHub-Event: ping" \
  -d '{"zen": "Design for failure."}'
```

---

### ❗ **Troubleshooting**

**Issue**: `GITHUB_TOKEN` not found
- **Solution**: Verify secret name matches exactly: `OB1_GITHUB_TOKEN`
- **Check**: Ensure secret is in correct project (IO Intelligence)

**Issue**: Webhook validation fails  
- **Solution**: Verify `OB1_WEBHOOK_SECRET` is correctly configured
- **Check**: Ensure secret matches between GitHub webhook settings and IO.NET

**Issue**: Deployment fails to start
- **Solution**: Check container logs for specific error messages
- **Check**: Verify all required environment variables are set

---

### 📞 **Support**

For issues with:
- **Secret management**: Contact IO.NET support
- **GitHub integration**: Check GitHub webhook delivery logs
- **OB-1 functionality**: Review application logs via `/health` endpoint

---

**🚀 Your OB-1 Enhanced deployment is now ready with proper secret management!**