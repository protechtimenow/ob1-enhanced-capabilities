#!/bin/bash

# OB-1 <-> GitHub Copilot MCP Installation Script

echo "🚀 Installing OB-1 <-> GitHub Copilot MCP Toolset..."

# Check requirements
echo "📋 Checking requirements..."

if ! command -v node &> /dev/null; then
    echo "❌ Node.js is not installed. Please install Node.js 18+ first."
    exit 1
fi

if ! command -v npm &> /dev/null; then
    echo "❌ npm is not installed. Please install npm first."
    exit 1
fi

# Check Node.js version
NODE_VERSION=$(node -v | sed 's/v//' | cut -d. -f1)
if [ "$NODE_VERSION" -lt 18 ]; then
    echo "❌ Node.js version 18+ is required. Current version: $(node -v)"
    exit 1
fi

echo "✅ Node.js $(node -v) found"
echo "✅ npm $(npm -v) found"

# Install dependencies
echo "📦 Installing dependencies..."
npm install

if [ $? -ne 0 ]; then
    echo "❌ Failed to install dependencies"
    exit 1
fi

echo "✅ Dependencies installed successfully"

# Build project
echo "🏗️ Building project..."
npm run build

if [ $? -ne 0 ]; then
    echo "❌ Failed to build project"
    exit 1
fi

echo "✅ Project built successfully"

# Setup environment
echo "⚙️ Setting up environment..."

if [ ! -f .env ]; then
    cp .env.example .env
    echo "📝 Created .env file from template"
    echo "⚠️  Please edit .env file with your API keys before starting the server"
else
    echo "📝 .env file already exists"
fi

# Create VS Code settings if needed
echo "🔧 Setting up VS Code integration..."

VSCODE_SETTINGS_DIR="$HOME/.vscode/settings.json"
TOOLSET_PATH="$(pwd)/dist/index.js"

if [ -f "$VSCODE_SETTINGS_DIR" ]; then
    echo "📝 VS Code settings file already exists"
    echo "📋 Add the following to your VS Code settings.json:"
else
    echo "📝 Creating VS Code settings template..."
    mkdir -p "$(dirname "$VSCODE_SETTINGS_DIR")"
fi

cat > vscode-settings-template.json << EOF
{
  "mcp.servers": {
    "ob1-copilot": {
      "command": "node",
      "args": ["$TOOLSET_PATH"],
      "env": {
        "NODE_ENV": "production"
      }
    }
  }
}
EOF

echo "📋 VS Code settings template created: vscode-settings-template.json"

# Test installation
echo "🧪 Testing installation..."

if [ -f dist/index.js ]; then
    echo "✅ MCP server built successfully"
else
    echo "❌ MCP server build failed"
    exit 1
fi

# Success message
echo ""
echo "🎉 Installation completed successfully!"
echo ""
echo "📋 Next steps:"
echo "1. Edit .env file with your API keys"
echo "2. Add MCP server configuration to VS Code (see vscode-settings-template.json)"
echo "3. Start the server with: npm start"
echo "4. Test with: npm run dev"
echo ""
echo "📖 Documentation: README.md"
echo "🐛 Issues: https://github.com/protechtimenow/ob1-enhanced-capabilities/issues"
echo ""
echo "🚀 Ready for AI-powered blockchain development!"