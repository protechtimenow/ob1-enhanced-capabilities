import json
import os
from datetime import datetime
from typing import Dict, Any, Optional, List

# In-memory storage for demo (use Redis/DB in production)
activity_log = []
user_sessions = {}
performance_metrics = {
    'total_requests': 0,
    'average_response_time': 0,
    'engine_usage': {'ob1': 0, 'copilot': 0, 'r2d2': 0},
    'error_count': 0
}

def log_engine_activity(
    engine: str, 
    action: str, 
    params: Dict[str, Any], 
    result: Dict[str, Any] = None,
    user_wallet: str = None,
    performance_ms: int = None
):
    """Log AI engine activity with enhanced tracking"""
    global activity_log, performance_metrics
    
    log_entry = {
        'timestamp': datetime.utcnow().isoformat(),
        'engine': engine,
        'action': action,
        'params': params,
        'result': result,
        'user_wallet': user_wallet,
        'performance_ms': performance_ms,
        'success': result and not result.get('error')
    }
    
    activity_log.append(log_entry)
    
    # Update metrics
    performance_metrics['total_requests'] += 1
    if engine in performance_metrics['engine_usage']:
        performance_metrics['engine_usage'][engine] += 1
    
    if performance_ms:
        current_avg = performance_metrics.get('average_response_time', 0)
        total_requests = performance_metrics['total_requests']
        performance_metrics['average_response_time'] = (
            (current_avg * (total_requests - 1) + performance_ms) / total_requests
        )
    
    if result and result.get('error'):
        performance_metrics['error_count'] += 1
    
    # Keep only last 1000 entries
    if len(activity_log) > 1000:
        activity_log = activity_log[-1000:]
    
    return log_entry

def track_user_session(session_id: str, user_wallet: str = None):
    """Track user sessions"""
    global user_sessions
    
    if session_id not in user_sessions:
        user_sessions[session_id] = {
            'user_wallet': user_wallet,
            'start_time': datetime.utcnow().isoformat(),
            'request_count': 0,
            'last_activity': datetime.utcnow().isoformat()
        }
    
    user_sessions[session_id]['request_count'] += 1
    user_sessions[session_id]['last_activity'] = datetime.utcnow().isoformat()
    
    return user_sessions[session_id]

def get_user_analytics(user_wallet: str = None) -> Dict[str, Any]:
    """Get analytics for specific user or overall"""
    if user_wallet:
        user_logs = [log for log in activity_log if log.get('user_wallet') == user_wallet]
        user_session = next(
            (session for session in user_sessions.values() 
             if session.get('user_wallet') == user_wallet), 
            None
        )
        
        return {
            'user_wallet': user_wallet,
            'total_requests': len(user_logs),
            'successful_requests': len([log for log in user_logs if log.get('success')]),
            'failed_requests': len([log for log in user_logs if not log.get('success')]),
            'session_info': user_session,
            'most_used_engine': get_most_used_engine(user_logs),
            'average_response_time': calculate_avg_response_time(user_logs)
        }
    else:
        return {
            'total_users': len(set(log.get('user_wallet') for log in activity_log if log.get('user_wallet'))),
            'total_requests': len(activity_log),
            'active_sessions': len(user_sessions),
            'global_metrics': performance_metrics
        }

def get_performance_metrics() -> Dict[str, Any]:
    """Get current performance metrics"""
    return performance_metrics.copy()

def get_most_used_engine(logs: List[Dict[str, Any]]) -> str:
    """Find most frequently used engine in logs"""
    engine_counts = {}
    for log in logs:
        engine = log.get('engine', 'unknown')
        engine_counts[engine] = engine_counts.get(engine, 0) + 1
    
    return max(engine_counts.items(), key=lambda x: x[1])[0] if engine_counts else 'none'

def calculate_avg_response_time(logs: List[Dict[str, Any]]) -> float:
    """Calculate average response time from logs"""
    response_times = [log.get('performance_ms', 0) for log in logs if log.get('performance_ms')]
    return sum(response_times) / len(response_times) if response_times else 0

def export_logs_to_file(filename: str = None) -> str:
    """Export activity logs to file"""
    if not filename:
        filename = f"logs/activity_export_{datetime.utcnow().strftime('%Y%m%d_%H%M%S')}.json"
    
    os.makedirs(os.path.dirname(filename), exist_ok=True)
    
    export_data = {
        'export_timestamp': datetime.utcnow().isoformat(),
        'total_logs': len(activity_log),
        'performance_metrics': performance_metrics,
        'user_sessions': user_sessions,
        'activity_log': activity_log
    }
    
    with open(filename, 'w') as f:
        json.dump(export_data, f, indent=2, default=str)
    
    return filename