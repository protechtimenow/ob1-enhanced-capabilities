#!/usr/bin/env python3
"""
OB-1 Enhanced Capabilities Setup Script
Comprehensive setup for all dependencies and environment configuration
"""

import os
import sys
import subprocess
import json
from pathlib import Path

def check_python_version():
    """Check if Python version meets requirements"""
    if sys.version_info < (3, 8):
        print("❌ Python 3.8+ is required. Current version:", sys.version)
        return False
    print("✅ Python version check passed:", sys.version)
    return True

def create_directories():
    """Create necessary directories"""
    directories = [
        'logs',
        'data', 
        'config',
        'temp',
        '.env'
    ]
    
    for directory in directories:
        if directory == '.env':
            continue  # Skip creating .env as a directory
        
        os.makedirs(directory, exist_ok=True)
        print(f"✅ Created directory: {directory}")

def install_dependencies():
    """Install Python dependencies"""
    try:
        print("📦 Installing Python dependencies...")
        subprocess.check_call([sys.executable, "-m", "pip", "install", "-r", "requirements.txt"])
        print("✅ Dependencies installed successfully")
        return True
    except subprocess.CalledProcessError as e:
        print(f"❌ Failed to install dependencies: {e}")
        return False

def create_env_file():
    """Create .env file from .env.example if it doesn't exist"""
    if not os.path.exists('.env') and os.path.exists('.env.example'):
        import shutil
        shutil.copy('.env.example', '.env')
        print("✅ Created .env file from .env.example")
        print("⚠️  Please edit .env file and add your API keys")
        return True
    elif os.path.exists('.env'):
        print("✅ .env file already exists")
        return True
    else:
        print("❌ .env.example not found")
        return False

def verify_environment():
    """Verify environment setup"""
    issues = []
    
    # Check for critical environment variables
    critical_vars = ['OPENAI_API_KEY', 'GITHUB_TOKEN']
    
    for var in critical_vars:
        if not os.getenv(var):
            issues.append(f"Missing environment variable: {var}")
    
    if issues:
        print("⚠️  Environment issues found:")
        for issue in issues:
            print(f"   - {issue}")
        print("   Please update your .env file")
        return False
    
    print("✅ Environment verification passed")
    return True

def test_imports():
    """Test if all modules can be imported"""
    try:
        # Test main application imports
        from utils.persistence import log_engine_activity
        from ai_engines.ob1 import OB1Client
        from ai_engines.copilot import CopilotClient
        from ai_engines.r2d2 import R2D2Client
        from commands.repository import create_repo
        
        print("✅ All module imports successful")
        return True
    except ImportError as e:
        print(f"❌ Import error: {e}")
        return False

def create_health_check():
    """Create a health check script"""
    health_script = '''#!/usr/bin/env python3
"""Health check script for OB-1 Enhanced Capabilities"""

import requests
import sys
import os

def check_health():
    try:
        port = os.environ.get('PORT', 5000)
        response = requests.get(f'http://localhost:{port}/health', timeout=10)
        
        if response.status_code == 200:
            data = response.json()
            print("✅ Application is healthy")
            print(f"Status: {data.get('status')}")
            print(f"Engines: {data.get('engines')}")
            return True
        else:
            print(f"❌ Health check failed with status {response.status_code}")
            return False
            
    except requests.exceptions.RequestException as e:
        print(f"❌ Health check failed: {e}")
        return False

if __name__ == '__main__':
    if check_health():
        sys.exit(0)
    else:
        sys.exit(1)
'''
    
    with open('health_check.py', 'w') as f:
        f.write(health_script)
    
    # Make it executable
    os.chmod('health_check.py', 0o755)
    print("✅ Created health_check.py script")

def main():
    """Main setup function"""
    print("🚀 OB-1 Enhanced Capabilities Setup")
    print("=" * 50)
    
    success = True
    
    # Run all setup steps
    steps = [
        ("Checking Python version", check_python_version),
        ("Creating directories", create_directories),
        ("Installing dependencies", install_dependencies),
        ("Creating environment file", create_env_file),
        ("Testing imports", test_imports),
        ("Creating health check", create_health_check),
    ]
    
    for step_name, step_func in steps:
        print(f"\n🔄 {step_name}...")
        if not step_func():
            success = False
            print(f"❌ {step_name} failed")
            break
        print(f"✅ {step_name} completed")
    
    print("\n" + "=" * 50)
    
    if success:
        print("🎉 Setup completed successfully!")
        print("\nNext steps:")
        print("1. Edit .env file with your API keys")
        print("2. Run: python main.py")
        print("3. Test with: python health_check.py")
        print("4. Or use Docker: docker-compose up")
    else:
        print("❌ Setup failed. Please resolve the issues and try again.")
        sys.exit(1)

if __name__ == "__main__":
    main()