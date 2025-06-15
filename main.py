python

from flask import Flask, request, jsonify
import yaml
import os
import json
from datetime import datetime
from utils.persistence import log_engine_activity, track_user_session
from ai_engines.ob1 import OB1Client
from ai_engines.copilot import CopilotClient
from ai_engines.r2d2 import R2D2Client
from commands.repository import create_repo, deploy_ai_code, analyze_repository

app = Flask(__name__)

# Load configuration
try:
    with open('config.yaml', 'r') as f:
        cfg = yaml.safe_load(f)
except:
    cfg = {
        'ai_engines': {
            'ob1': {'enabled': True},
            'copilot': {'enabled': True},
            'r2d2': {'enabled': False}
        }
    }

# Initialize AI engines
ob1_client = OB1Client()
copilot_client = CopilotClient()
r2d2_client = R2D2Client()

def get_user_wallet_from_request():
    """Extract user wallet from request headers or params"""
    return request.headers.get('X-User-Wallet') or request.json.get('user_wallet') if request.json else None

@app.route('/')
def index():
    user_wallet = get_user_wallet_from_request()
    log_engine_activity('system', 'index_access', {}, user_wallet=user_wallet)
    
    return jsonify({
        'service': 'OB-1 Enhanced Multi-Engine AI Infrastructure',
        'version': '1.0',
        'status': 'Active',
        'available_engines': ['ob1', 'copilot', 'r2d2'],
        'endpoints': ['/ai-command', '/github-webhook', '/health', '/analytics'],
        'user_wallet': user_wallet,
        'timestamp': datetime.utcnow().isoformat()
    })

@app.route('/health')
def health():
    user_wallet = get_user_wallet_from_request()
    
    health_status = {
        'status': 'healthy',
        'timestamp': datetime.utcnow().isoformat(),
        'engines': {
            'ob1': 'active',
            'copilot': 'active' if copilot_client.available else 'fallback_mode',
            'r2d2': 'coming_soon'
        },
        'github_token': 'configured' if os.getenv('GITHUB_TOKEN') else 'missing'
    }
    
    log_engine_activity('system', 'health_check', {}, health_status, user_wallet=user_wallet)
    return jsonify(health_status)

@app.route('/ai-command', methods=['POST'])
def ai_command():
    """Multi-engine AI command processor"""
    start_time = datetime.utcnow()
    data = request.json or {}
    user_wallet = get_user_wallet_from_request() or data.get('user_wallet')
    
    action = data.get('action')
    params = data.get('params', {})
    engine = params.get('engine', 'ob1')
    
    # Track user session
    if user_wallet:
        track_user_session(f"session_{user_wallet}", user_wallet)
    
    try:
        if action == 'analyze_text':
            result = handle_text_analysis(engine, params, user_wallet)
        elif action == 'suggest_code':
            result = handle_code_suggestion(engine, params, user_wallet)
        elif action == 'create_repository':
            result = create_repo(params, user_wallet)
        elif action == 'deploy_code':
            result = deploy_ai_code(params, user_wallet)
        elif action == 'analyze_repository':
            result = analyze_repository(params, user_wallet)
        elif action == 'switch_engine':
            result = switch_ai_engine(params, user_wallet)
        else:
            result = {
                'error': f'Unknown action: {action}',
                'available_actions': [
                    'analyze_text', 'suggest_code', 'create_repository', 
                    'deploy_code', 'analyze_repository', 'switch_engine'
                ]
            }
        
        # Calculate performance
        performance_ms = int((datetime.utcnow() - start_time).total_seconds() * 1000)
        result['performance_ms'] = performance_ms
        result['engine_used'] = engine
        result['timestamp'] = datetime.utcnow().isoformat()
        
        log_engine_activity(engine, action, params, result, 
                          user_wallet=user_wallet, performance_ms=performance_ms)
        
        return jsonify(result)
        
    except Exception as e:
        error_result = {
            'error': str(e),
            'action': action,
            'engine': engine,
            'status': 'failed'
        }
        log_engine_activity(engine, action, params, error_result, user_wallet=user_wallet)
        return jsonify(error_result), 500

def handle_text_analysis(engine, params, user_wallet):
    """Handle text analysis across different engines"""
    text = params.get('text', '')
    context = params.get('context', {})
    
    if engine == 'ob1':
        return ob1_client.analyze(text, context)
    elif engine == 'r2d2':
        return r2d2_client.analyze(text, context)
    elif engine == 'copilot':
        return copilot_client.suggest(prompt=text)
    else:
        return {'error': f'Engine {engine} not supported for text analysis'}

def handle_code_suggestion(engine, params, user_wallet):
    """Handle code suggestions across engines"""
    prompt = params.get('prompt', '')
    file_path = params.get('file_path')
    
    if engine == 'copilot':
        return copilot_client.suggest(file_path, prompt)
    elif engine == 'ob1':
        return ob1_client.analyze(f"Generate code for: {prompt}")
    elif engine == 'r2d2':
        return r2d2_client.suggest(prompt)
    else:
        return {'error': f'Engine {engine} not supported for code suggestions'}

def switch_ai_engine(params, user_wallet):
    """Switch between AI engines"""
    target_engine = params.get('target_engine')
    available_engines = ['ob1', 'copilot', 'r2d2']
    
    if target_engine not in available_engines:
        return {
            'error': f'Invalid engine: {target_engine}',
            'available_engines': available_engines
        }
    
    return {
        'status': 'engine_switched',
        'active_engine': target_engine,
        'capabilities': get_engine_capabilities(target_engine)
    }

def get_engine_capabilities(engine):
    """Get capabilities for specific engine"""
    capabilities = {
        'ob1': ['text_analysis', 'blockchain_analysis', 'defi_analysis', 'security_analysis'],
        'copilot': ['code_suggestions', 'code_explanation', 'cli_integration'],
        'r2d2': ['coming_soon', 'multi_modal_analysis', 'advanced_reasoning']
    }
    return capabilities.get(engine, [])

@app.route('/github-webhook', methods=['POST'])
def github_webhook():
    """Enhanced GitHub webhook with multi-engine analysis"""
    payload = request.json or {}
    event_type = request.headers.get('X-GitHub-Event', 'unknown')
    user_wallet = get_user_wallet_from_request()
    
    # Analyze with OB-1
    if event_type == 'push':
        commits = payload.get('commits', [])
        analysis_results = []
        
        for commit in commits:
            message = commit.get('message', '')
            ob1_analysis = ob1_client.analyze(message, {'event_type': 'git_commit'})
            analysis_results.append({
                'commit_id': commit.get('id'),
                'analysis': ob1_analysis
            })
        
        result = {
            'status': 'webhook_processed',
            'event_type': event_type,
            'commits_analyzed': len(commits),
            'ai_analysis': analysis_results,
            'timestamp': datetime.utcnow().isoformat()
        }
    else:
        result = {
            'status': 'webhook_received',
            'event_type': event_type,
            'ai_processing': 'basic_logging',
            'timestamp': datetime.utcnow().isoformat()
        }
    
    log_engine_activity('webhook', event_type, payload, result, user_wallet=user_wallet)
    return jsonify(result)

@app.route('/analytics')
def analytics():
    """Get multi-engine analytics"""
    user_wallet = get_user_wallet_from_request()
    
    from utils.persistence import get_user_analytics, get_performance_metrics
    
    if user_wallet:
        analytics = get_user_analytics(user_wallet)
    else:
        analytics = get_user_analytics()
    
    performance = get_performance_metrics()
    
    return jsonify({
        'analytics': analytics,
        'performance': performance,
        'timestamp': datetime.utcnow().isoformat()
    })

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=int(os.environ.get('PORT', 5000)))
