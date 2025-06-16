#!/usr/bin/env python3
"""
OB-1 Enhanced Capabilities Quick Start Script
Easy way to run the application with proper error handling and logging
"""

import os
import sys
import signal
import subprocess
from datetime import datetime

def setup_environment():
    """Setup environment variables and paths"""
    # Add current directory to Python path
    current_dir = os.path.dirname(os.path.abspath(__file__))
    if current_dir not in sys.path:
        sys.path.insert(0, current_dir)
    
    # Set PYTHONPATH environment variable
    os.environ['PYTHONPATH'] = current_dir
    
    print(f"📁 Working directory: {current_dir}")
    print(f"🐍 Python path: {sys.path[0]}")

def check_dependencies():
    """Check if all required dependencies are installed"""
    try:
        import flask
        import yaml
        import openai
        import requests
        print("✅ Core dependencies found")
        return True
    except ImportError as e:
        print(f"❌ Missing dependency: {e}")
        print("💡 Run: python setup.py")
        return False

def load_environment():
    """Load environment variables from .env file"""
    env_file = '.env'
    if os.path.exists(env_file):
        print(f"📄 Loading environment from {env_file}")
        with open(env_file, 'r') as f:
            for line in f:
                line = line.strip()
                if line and not line.startswith('#') and '=' in line:
                    key, value = line.split('=', 1)
                    os.environ[key.strip()] = value.strip()
        print("✅ Environment variables loaded")
        return True
    else:
        print(f"⚠️  {env_file} not found. Using default config.")
        return False

def start_application():
    """Start the main application"""
    try:
        print("🚀 Starting OB-1 Enhanced Capabilities...")
        print(f"⏰ Timestamp: {datetime.now().isoformat()}")
        
        # Import and run the main application
        from main import app
        
        # Get configuration
        host = os.environ.get('HOST', '0.0.0.0')
        port = int(os.environ.get('PORT', 5000))
        debug = os.environ.get('FLASK_ENV', 'production') == 'development'
        
        print(f"🌐 Starting server on {host}:{port}")
        print(f"🔧 Debug mode: {debug}")
        print("🔗 Available endpoints:")
        print(f"   - Health check: http://localhost:{port}/health")
        print(f"   - API endpoint: http://localhost:{port}/ai-command")
        print(f"   - Analytics: http://localhost:{port}/analytics")
        print("=" * 50)
        
        # Start the Flask application
        app.run(host=host, port=port, debug=debug, threaded=True)
        
    except KeyboardInterrupt:
        print("\n🛑 Application stopped by user")
        sys.exit(0)
    except Exception as e:
        print(f"💥 Application failed to start: {e}")
        print("💡 Troubleshooting:")
        print("   1. Check your .env file")
        print("   2. Verify API keys are set")
        print("   3. Run: python setup.py")
        print("   4. Check logs in logs/ directory")
        sys.exit(1)

def signal_handler(signum, frame):
    """Handle graceful shutdown"""
    print("\n🔄 Received shutdown signal...")
    print("✅ OB-1 Enhanced Capabilities stopped gracefully")
    sys.exit(0)

def main():
    """Main entry point"""
    print("🤖 OB-1 Enhanced AI Capabilities")
    print("=" * 50)
    
    # Setup signal handlers for graceful shutdown
    signal.signal(signal.SIGINT, signal_handler)
    signal.signal(signal.SIGTERM, signal_handler)
    
    # Run setup steps
    setup_environment()
    
    if not check_dependencies():
        print("\n💡 Please run setup first:")
        print("   python setup.py")
        sys.exit(1)
    
    load_environment()
    start_application()

if __name__ == "__main__":
    main()