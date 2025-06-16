"""
OB-1 Enhanced Capabilities - Commands Module

This module contains command implementations for repository management,
deployment, and analysis functionality.
"""

from .repository import (
    create_repo,
    deploy_ai_code,
    analyze_repository
)

__all__ = [
    'create_repo',
    'deploy_ai_code',
    'analyze_repository'
]

__version__ = "1.0.0"

# Command registry for dynamic execution
COMMAND_REGISTRY = {
    'create_repository': create_repo,
    'deploy_code': deploy_ai_code,
    'analyze_repository': analyze_repository
}

def execute_command(command_name: str, params: dict, user_wallet: str = None):
    """
    Factory function to execute a command by name.
    
    Args:
        command_name (str): Name of the command to execute
        params (dict): Parameters for the command
        user_wallet (str): Optional user wallet address
        
    Returns:
        dict: Command execution result
    """
    command_func = COMMAND_REGISTRY.get(command_name)
    if command_func:
        return command_func(params, user_wallet)
    else:
        return {
            'error': f'Unknown command: {command_name}',
            'available_commands': list(COMMAND_REGISTRY.keys())
        }

def list_available_commands():
    """
    Get list of available commands.
    
    Returns:
        list: List of available command names
    """
    return list(COMMAND_REGISTRY.keys())