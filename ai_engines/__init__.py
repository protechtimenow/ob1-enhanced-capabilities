"""
OB-1 Enhanced Capabilities - AI Engines Module

This module contains AI engine implementations including OB-1, GitHub Copilot, 
and R2D2 integrations for multi-engine AI capabilities.
"""

from .ob1 import OB1Client
from .copilot import CopilotClient
from .r2d2 import R2D2Client

__all__ = [
    'OB1Client',
    'CopilotClient', 
    'R2D2Client'
]

__version__ = "1.0.0"

# Engine registry for dynamic loading
ENGINE_REGISTRY = {
    'ob1': OB1Client,
    'copilot': CopilotClient,
    'r2d2': R2D2Client
}

def get_engine(engine_name: str):
    """
    Factory function to get an AI engine instance by name.
    
    Args:
        engine_name (str): Name of the engine ('ob1', 'copilot', 'r2d2')
        
    Returns:
        AI engine instance or None if not found
    """
    engine_class = ENGINE_REGISTRY.get(engine_name.lower())
    if engine_class:
        return engine_class()
    return None

def list_available_engines():
    """
    Get list of available AI engines.
    
    Returns:
        list: List of available engine names
    """
    return list(ENGINE_REGISTRY.keys())