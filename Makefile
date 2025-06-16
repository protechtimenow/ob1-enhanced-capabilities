# OB-1 Enhanced Capabilities - Makefile
# Easy commands for development and deployment

.PHONY: help setup install clean run test docker deploy health

# Default target
help:
	@echo "🤖 OB-1 Enhanced Capabilities - Available Commands"
	@echo "=================================================="
	@echo ""
	@echo "Setup & Installation:"
	@echo "  make setup      - Run complete setup process"
	@echo "  make install    - Install Python dependencies only"
	@echo "  make clean      - Clean temporary files and logs"
	@echo ""
	@echo "Development:"
	@echo "  make run        - Start the application (development)"
	@echo "  make test       - Run tests and health checks"
	@echo "  make health     - Check application health"
	@echo ""
	@echo "Docker:"
	@echo "  make docker     - Build and run Docker container"
	@echo "  make docker-build - Build Docker image only"
	@echo "  make docker-run   - Run existing Docker image"
	@echo ""
	@echo "Deployment:"
	@echo "  make deploy     - Deploy to production"
	@echo "  make logs       - View application logs"
	@echo ""
	@echo "Maintenance:"
	@echo "  make backup     - Backup configuration and data"
	@echo "  make update     - Update dependencies"
	@echo ""

# Setup and Installation
setup:
	@echo "🚀 Starting OB-1 Enhanced Capabilities Setup..."
	@python setup.py

install:
	@echo "📦 Installing Python dependencies..."
	@pip install -r requirements.txt

clean:
	@echo "🧹 Cleaning temporary files..."
	@rm -rf __pycache__ */__pycache__ */*/__pycache__
	@rm -rf *.pyc */*.pyc */*/*.pyc
	@rm -rf .pytest_cache
	@rm -rf logs/*.log
	@rm -rf temp/*
	@echo "✅ Cleanup completed"

# Development
run:
	@echo "🚀 Starting OB-1 Enhanced Capabilities..."
	@python run.py

test:
	@echo "🧪 Running tests and health checks..."
	@python setup.py
	@echo "Testing imports..."
	@python -c "from utils import persistence; from ai_engines import ob1; from commands import repository; print('✅ All imports successful')"
	@echo "✅ Tests completed"

health:
	@echo "🏥 Checking application health..."
	@python health_check.py || echo "❌ Health check failed - is the application running?"

# Docker Operations
docker: docker-build docker-run

docker-build:
	@echo "🐳 Building Docker image..."
	@docker build -t ob1-enhanced .
	@echo "✅ Docker image built successfully"

docker-run:
	@echo "🚀 Running Docker container..."
	@docker run -p 5000:5000 \
		--env-file .env \
		--name ob1-enhanced-container \
		ob1-enhanced

docker-stop:
	@echo "🛑 Stopping Docker container..."
	@docker stop ob1-enhanced-container || true
	@docker rm ob1-enhanced-container || true

# Production Deployment
deploy:
	@echo "🚀 Deploying to production..."
	@echo "Checking environment..."
	@test -f .env || (echo "❌ .env file not found" && exit 1)
	@echo "Building production image..."
	@docker build -t ob1-enhanced:latest .
	@echo "Starting production container..."
	@docker-compose up -d
	@echo "✅ Deployment completed"

# Monitoring and Logs
logs:
	@echo "📋 Viewing application logs..."
	@tail -f logs/ob1-agent.log

logs-error:
	@echo "📋 Viewing error logs..."
	@tail -f logs/error.log || echo "No error logs found"

# Maintenance
backup:
	@echo "💾 Creating backup..."
	@mkdir -p backups
	@tar -czf backups/ob1-backup-$$(date +%Y%m%d-%H%M%S).tar.gz \
		.env config.yaml logs/ data/ --exclude=logs/*.log
	@echo "✅ Backup created in backups/ directory"

update:
	@echo "🔄 Updating dependencies..."
	@pip install --upgrade -r requirements.txt
	@echo "✅ Dependencies updated"

# Development Helpers
dev-server:
	@echo "🧪 Starting development server with hot reload..."
	@export FLASK_ENV=development && python run.py

prod-server:
	@echo "🚀 Starting production server..."
	@gunicorn --bind 0.0.0.0:5000 --workers 2 main:app

# Environment Setup
env-check:
	@echo "🔍 Checking environment configuration..."
	@python -c "import os; print('✅ GITHUB_TOKEN:', 'SET' if os.getenv('GITHUB_TOKEN') else '❌ MISSING')"
	@python -c "import os; print('✅ OPENAI_API_KEY:', 'SET' if os.getenv('OPENAI_API_KEY') else '❌ MISSING')"
	@python -c "import os; print('✅ PORT:', os.getenv('PORT', '5000 (default)'))"

env-create:
	@echo "📄 Creating .env file from template..."
	@cp .env.example .env
	@echo "✅ .env file created - please edit with your credentials"

# Quick Start (recommended for first-time users)
quickstart:
	@echo "🚀 OB-1 Enhanced Capabilities - Quick Start"
	@echo "==========================================="
	@make env-create
	@make setup
	@echo ""
	@echo "🎉 Setup completed! Next steps:"
	@echo "1. Edit .env file with your API keys"
	@echo "2. Run: make run"
	@echo "3. Test: make health"
	@echo ""