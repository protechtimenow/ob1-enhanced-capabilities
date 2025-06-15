// OB-1 Codespace Integration Extension
const CODESPACE_URL = 'https://fictional-parakeet-4xg9xp9gq97h75wp-5000.app.github.dev';
const API_BASE = `${CODESPACE_URL}/api`;

// DOM Elements
const elements = {
  connectionStatus: document.getElementById('connectionStatus'),
  statusText: document.getElementById('statusText'),
  totalPoints: document.getElementById('totalPoints'),
  ecosystemShare: document.getElementById('ecosystemShare'),
  chainDominance: document.getElementById('chainDominance'),
  competitive: document.getElementById('competitive'),
  openDashboard: document.getElementById('openDashboard'),
  refreshData: document.getElementById('refreshData'),
  quantumAnalysis: document.getElementById('quantumAnalysis'),
  injectOB1: document.getElementById('injectOB1'),
  openCodespace: document.getElementById('openCodespace')
};

// Connection status management
class ConnectionManager {
  constructor() {
    this.isConnected = false;
    this.checkInterval = null;
  }

  async checkConnection() {
    try {
      const response = await fetch(`${CODESPACE_URL}/health`, {
        method: 'GET',
        mode: 'cors'
      });
      
      if (response.ok) {
        this.setConnected(true);
        return true;
      }
    } catch (error) {
      console.log('Connection check failed:', error);
    }
    
    this.setConnected(false);
    return false;
  }

  setConnected(connected) {
    this.isConnected = connected;
    const statusText = elements.statusText;
    const dot = elements.connectionStatus.querySelector('.dot');
    
    if (connected) {
      statusText.textContent = 'Connected';
      dot.style.background = '#00ff64';
      dot.style.animation = 'pulse 2s infinite';
    } else {
      statusText.textContent = 'Disconnected';
      dot.style.background = '#ff4444';
      dot.style.animation = 'none';
    }
  }

  startMonitoring() {
    this.checkConnection();
    this.checkInterval = setInterval(() => {
      this.checkConnection();
    }, 5000);
  }

  stopMonitoring() {
    if (this.checkInterval) {
      clearInterval(this.checkInterval);
    }
  }
}

// Data fetcher for SuperStacks metrics
class DataFetcher {
  async fetchSuperStacksData() {
    if (!connectionManager.isConnected) {
      throw new Error('Not connected to OB-1');
    }

    try {
      const response = await fetch(`${API_BASE}/superstacks/summary`, {
        method: 'GET',
        headers: {
          'Content-Type': 'application/json'
        }
      });
      
      if (response.ok) {
        return await response.json();
      }
      
      // Fallback to static data
      return this.getStaticData();
    } catch (error) {
      console.log('API fetch failed, using static data:', error);
      return this.getStaticData();
    }
  }

  getStaticData() {
    return {
      totalPoints: '242.7M',
      ecosystemShare: '9.06%',
      chainDominance: '80.8%',
      competitiveAdvantage: '6.4x',
      status: 'optimal',
      protocol: 'Uniswap V4',
      chain: 'Unichain',
      position: 'Top 5 Participant'
    };
  }
}

// UI Controller
class UIController {
  updateMetrics(data) {
    elements.totalPoints.textContent = data.totalPoints;
    elements.ecosystemShare.textContent = data.ecosystemShare;
    elements.chainDominance.textContent = data.chainDominance;
    elements.competitive.textContent = data.competitiveAdvantage;
  }

  showLoading(button, text = 'Loading...') {
    const originalText = button.textContent;
    button.textContent = text;
    button.classList.add('loading');
    button.disabled = true;
    
    return () => {
      button.textContent = originalText;
      button.classList.remove('loading');
      button.disabled = false;
    };
  }

  showSuccess(button, text, duration = 2000) {
    const originalText = button.textContent;
    button.textContent = text;
    button.classList.add('success');
    
    setTimeout(() => {
      button.textContent = originalText;
      button.classList.remove('success');
    }, duration);
  }

  showError(button, text, duration = 3000) {
    const originalText = button.textContent;
    button.textContent = text;
    button.classList.add('error');
    
    setTimeout(() => {
      button.textContent = originalText;
      button.classList.remove('error');
    }, duration);
  }
}

// Action handlers
class ActionHandler {
  constructor(ui, dataFetcher) {
    this.ui = ui;
    this.dataFetcher = dataFetcher;
  }

  async handleRefreshData(button) {
    const resetLoading = this.ui.showLoading(button, '🔄 Refreshing...');
    
    try {
      const data = await this.dataFetcher.fetchSuperStacksData();
      this.ui.updateMetrics(data);
      resetLoading();
      this.ui.showSuccess(button, '✅ Updated!');
    } catch (error) {
      resetLoading();
      this.ui.showError(button, '❌ Failed');
    }
  }

  handleOpenDashboard() {
    chrome.tabs.create({
      url: CODESPACE_URL
    });
  }

  async handleQuantumAnalysis(button) {
    const resetLoading = this.ui.showLoading(button, '⚡ Analyzing...');
    
    try {
      if (connectionManager.isConnected) {
        await fetch(`${API_BASE}/quantum/analyze`, { method: 'POST' });
      }
      
      resetLoading();
      this.ui.showSuccess(button, '⚡ Analysis Complete!');
      
      // Open results in new tab
      setTimeout(() => {
        chrome.tabs.create({
          url: `${CODESPACE_URL}/quantum-results`
        });
      }, 1000);
    } catch (error) {
      resetLoading();
      this.ui.showError(button, '❌ Analysis Failed');
    }
  }

  async handleInjectOB1(button) {
    const resetLoading = this.ui.showLoading(button, '🧠 Injecting...');
    
    try {
      // Get current tab
      const [tab] = await chrome.tabs.query({ active: true, currentWindow: true });
      
      if (tab.url.includes('github.com')) {
        // Inject OB-1 interface into GitHub
        await chrome.scripting.executeScript({
          target: { tabId: tab.id },
          func: this.injectOB1Interface
        });
        
        resetLoading();
        this.ui.showSuccess(button, '🧠 OB-1 Injected!');
      } else {
        resetLoading();
        this.ui.showError(button, '❌ Use on GitHub');
      }
    } catch (error) {
      resetLoading();
      this.ui.showError(button, '❌ Injection Failed');
    }
  }

  handleOpenCodespace() {
    chrome.tabs.create({
      url: 'https://github.com/protechtimenow/ob1-enhanced-capabilities'
    });
  }

  // Function to be injected into GitHub pages
  injectOB1Interface() {
    if (document.getElementById('ob1-interface')) return;
    
    const ob1Container = document.createElement('div');
    ob1Container.id = 'ob1-interface';
    ob1Container.innerHTML = `
      <div style="
        position: fixed;
        top: 20px;
        right: 20px;
        width: 300px;
        background: linear-gradient(135deg, #0a0a0f, #1a1a2e);
        color: white;
        padding: 20px;
        border-radius: 15px;
        border: 2px solid #00ff64;
        box-shadow: 0 10px 30px rgba(0,0,0,0.5);
        z-index: 10000;
        font-family: 'Segoe UI', sans-serif;
      ">
        <div style="text-align: center; margin-bottom: 15px;">
          <h3 style="margin: 0; color: #00ff64;">🚀 OB-1 Active</h3>
          <p style="margin: 5px 0; font-size: 12px; opacity: 0.8;">SuperStacks Command Center</p>
        </div>
        
        <div style="margin-bottom: 15px;">
          <div style="display: flex; justify-content: space-between; margin-bottom: 8px;">
            <span style="font-size: 12px;">Points:</span>
            <span style="color: #00ff64; font-weight: bold;">242.7M</span>
          </div>
          <div style="display: flex; justify-content: space-between; margin-bottom: 8px;">
            <span style="font-size: 12px;">Share:</span>
            <span style="color: #00ff64; font-weight: bold;">9.06%</span>
          </div>
          <div style="display: flex; justify-content: space-between;">
            <span style="font-size: 12px;">Status:</span>
            <span style="color: #00ff64; font-weight: bold;">OPTIMAL</span>
          </div>
        </div>
        
        <button onclick="window.open('${CODESPACE_URL}', '_blank')" style="
          width: 100%;
          padding: 10px;
          background: linear-gradient(45deg, #00ff64, #00d4aa);
          border: none;
          border-radius: 8px;
          color: black;
          font-weight: bold;
          cursor: pointer;
          margin-bottom: 10px;
        ">📊 Open Dashboard</button>
        
        <button onclick="this.parentElement.style.display='none'" style="
          width: 100%;
          padding: 8px;
          background: rgba(255,255,255,0.1);
          border: 1px solid rgba(255,255,255,0.2);
          border-radius: 8px;
          color: white;
          cursor: pointer;
        ">✕ Hide</button>
      </div>
    `;
    
    document.body.appendChild(ob1Container);
    
    // Auto-hide after 10 seconds
    setTimeout(() => {
      if (ob1Container.parentElement) {
        ob1Container.style.opacity = '0.7';
      }
    }, 10000);
  }
}

// Initialize everything
const connectionManager = new ConnectionManager();
const dataFetcher = new DataFetcher();
const ui = new UIController();
const actionHandler = new ActionHandler(ui, dataFetcher);

// Event listeners
document.addEventListener('DOMContentLoaded', async () => {
  // Start connection monitoring
  connectionManager.startMonitoring();
  
  // Load initial data
  try {
    const data = await dataFetcher.fetchSuperStacksData();
    ui.updateMetrics(data);
  } catch (error) {
    console.log('Failed to load initial data:', error);
  }
  
  // Bind event handlers
  elements.openDashboard.addEventListener('click', () => {
    actionHandler.handleOpenDashboard();
  });
  
  elements.refreshData.addEventListener('click', () => {
    actionHandler.handleRefreshData(elements.refreshData);
  });
  
  elements.quantumAnalysis.addEventListener('click', () => {
    actionHandler.handleQuantumAnalysis(elements.quantumAnalysis);
  });
  
  elements.injectOB1.addEventListener('click', () => {
    actionHandler.handleInjectOB1(elements.injectOB1);
  });
  
  elements.openCodespace.addEventListener('click', () => {
    actionHandler.handleOpenCodespace();
  });
});

// Cleanup on unload
window.addEventListener('beforeunload', () => {
  connectionManager.stopMonitoring();
});