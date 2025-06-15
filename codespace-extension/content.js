// OB-1 Content Script for GitHub Integration

// Only run on GitHub pages
if (window.location.hostname === 'github.com') {
  console.log('OB-1: GitHub integration activated');
  
  // Initialize OB-1 GitHub enhancements
  initOB1GitHubEnhancements();
}

// Only run on OB-1 Codespace
if (window.location.hostname.includes('fictional-parakeet-4xg9xp9gq97h75wp-5000.app.github.dev')) {
  console.log('OB-1: Codespace integration activated');
  
  // Initialize OB-1 Codespace enhancements
  initOB1CodespaceEnhancements();
}

function initOB1GitHubEnhancements() {
  // Add OB-1 status indicator to GitHub header
  addOB1StatusToGitHub();
  
  // Enhance repository view with OB-1 insights
  if (isOB1Repository()) {
    addOB1RepositoryInsights();
  }
  
  // Add OB-1 quick actions to navigation
  addOB1QuickActions();
}

function addOB1StatusToGitHub() {
  const header = document.querySelector('.Header, .js-header-wrapper');
  if (!header || document.getElementById('ob1-github-status')) return;
  
  const statusDiv = document.createElement('div');
  statusDiv.id = 'ob1-github-status';
  statusDiv.innerHTML = `
    <div style="
      display: inline-flex;
      align-items: center;
      gap: 8px;
      background: linear-gradient(45deg, #0a0a0f, #1a1a2e);
      color: white;
      padding: 6px 12px;
      border-radius: 20px;
      border: 1px solid #00ff64;
      font-size: 12px;
      font-weight: 500;
      margin-left: 12px;
    ">
      <div style="
        width: 8px;
        height: 8px;
        border-radius: 50%;
        background: #00ff64;
        animation: ob1-pulse 2s infinite;
      "></div>
      <span>OB-1 Active</span>
      <button onclick="this.parentElement.parentElement.remove()" style="
        background: none;
        border: none;
        color: rgba(255,255,255,0.7);
        cursor: pointer;
        font-size: 14px;
        padding: 0;
        margin-left: 4px;
      ">×</button>
    </div>
    
    <style>
      @keyframes ob1-pulse {
        0% { opacity: 1; box-shadow: 0 0 0 0 rgba(0,255,100,0.7); }
        70% { opacity: 0.7; box-shadow: 0 0 0 10px rgba(0,255,100,0); }
        100% { opacity: 1; box-shadow: 0 0 0 0 rgba(0,255,100,0); }
      }
    </style>
  `;
  
  const nav = header.querySelector('.Header-item--full, .HeaderMenu');
  if (nav) {
    nav.appendChild(statusDiv);
  }
}

function isOB1Repository() {
  return window.location.pathname.includes('ob1-enhanced-capabilities') ||
         document.title.toLowerCase().includes('ob-1') ||
         document.querySelector('[data-content="OB-1"], [data-content="SuperStacks"]');
}

function addOB1RepositoryInsights() {
  const readmeSection = document.querySelector('#readme, .Box--responsive');
  if (!readmeSection || document.getElementById('ob1-repo-insights')) return;
  
  const insightsDiv = document.createElement('div');
  insightsDiv.id = 'ob1-repo-insights';
  insightsDiv.innerHTML = `
    <div style="
      background: linear-gradient(135deg, #0a0a0f, #1a1a2e);
      color: white;
      padding: 20px;
      border-radius: 15px;
      border: 2px solid #00ff64;
      margin: 20px 0;
      box-shadow: 0 8px 25px rgba(0,255,100,0.2);
    ">
      <h3 style="
        color: #00ff64;
        margin: 0 0 16px 0;
        display: flex;
        align-items: center;
        gap: 10px;
      ">
        🚀 OB-1 Repository Intelligence
      </h3>
      
      <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 16px; margin-bottom: 16px;">
        <div style="background: rgba(255,255,255,0.05); padding: 12px; border-radius: 8px; text-align: center;">
          <div style="color: #00ff64; font-size: 18px; font-weight: bold;">242.7M</div>
          <div style="font-size: 12px; opacity: 0.8;">SuperStacks Points</div>
        </div>
        
        <div style="background: rgba(255,255,255,0.05); padding: 12px; border-radius: 8px; text-align: center;">
          <div style="color: #00ff64; font-size: 18px; font-weight: bold;">OPTIMAL</div>
          <div style="font-size: 12px; opacity: 0.8;">Strategic Position</div>
        </div>
        
        <div style="background: rgba(255,255,255,0.05); padding: 12px; border-radius: 8px; text-align: center;">
          <div style="color: #00ff64; font-size: 18px; font-weight: bold;">ACTIVE</div>
          <div style="font-size: 12px; opacity: 0.8;">Quantum Status</div>
        </div>
      </div>
      
      <div style="display: flex; gap: 12px; flex-wrap: wrap;">
        <button onclick="window.open('https://fictional-parakeet-4xg9xp9gq97h75wp-5000.app.github.dev', '_blank')" style="
          padding: 10px 16px;
          background: linear-gradient(45deg, #00ff64, #00d4aa);
          border: none;
          border-radius: 8px;
          color: black;
          font-weight: bold;
          cursor: pointer;
          flex: 1;
          min-width: 120px;
        ">📊 Dashboard</button>
        
        <button onclick="window.open('https://github.com/protechtimenow/ob1-enhanced-capabilities/blob/main/README.md', '_blank')" style="
          padding: 10px 16px;
          background: rgba(255,255,255,0.1);
          border: 1px solid rgba(255,255,255,0.2);
          border-radius: 8px;
          color: white;
          font-weight: bold;
          cursor: pointer;
          flex: 1;
          min-width: 120px;
        ">📖 Docs</button>
        
        <button onclick="this.closest('div').style.display='none'" style="
          padding: 10px 16px;
          background: rgba(255,255,255,0.05);
          border: 1px solid rgba(255,255,255,0.1);
          border-radius: 8px;
          color: rgba(255,255,255,0.7);
          cursor: pointer;
        ">✕</button>
      </div>
    </div>
  `;
  
  readmeSection.parentNode.insertBefore(insightsDiv, readmeSection);
}

function addOB1QuickActions() {
  const navigation = document.querySelector('.UnderlineNav, .tabnav');
  if (!navigation || document.getElementById('ob1-quick-actions')) return;
  
  const quickActionsDiv = document.createElement('div');
  quickActionsDiv.id = 'ob1-quick-actions';
  quickActionsDiv.innerHTML = `
    <div style="
      position: fixed;
      top: 60px;
      right: 20px;
      background: linear-gradient(135deg, #0a0a0f, #1a1a2e);
      padding: 12px;
      border-radius: 12px;
      border: 1px solid rgba(255,255,255,0.2);
      z-index: 1000;
      min-width: 200px;
    ">
      <h4 style="color: #00ff64; margin: 0 0 10px 0; font-size: 14px;">⚡ Quick Actions</h4>
      
      <div style="display: flex; flex-direction: column; gap: 8px;">
        <button onclick="window.open('https://fictional-parakeet-4xg9xp9gq97h75wp-5000.app.github.dev', '_blank')" style="
          padding: 8px 12px;
          background: linear-gradient(45deg, #00ff64, #00d4aa);
          border: none;
          border-radius: 6px;
          color: black;
          font-size: 12px;
          font-weight: bold;
          cursor: pointer;
          width: 100%;
        ">🚀 OB-1 Dashboard</button>
        
        <button onclick="navigator.clipboard.writeText('0x21cC30462B8392Aa250453704019800092a16165').then(() => alert('Wallet copied!'))" style="
          padding: 8px 12px;
          background: rgba(255,255,255,0.1);
          border: 1px solid rgba(255,255,255,0.2);
          border-radius: 6px;
          color: white;
          font-size: 12px;
          cursor: pointer;
          width: 100%;
        ">📋 Copy Wallet</button>
        
        <button onclick="this.closest('div').style.display='none'" style="
          padding: 6px;
          background: none;
          border: none;
          color: rgba(255,255,255,0.5);
          font-size: 12px;
          cursor: pointer;
          align-self: center;
        ">✕ Hide</button>
      </div>
    </div>
  `;
  
  document.body.appendChild(quickActionsDiv);
  
  // Auto-hide after 10 seconds
  setTimeout(() => {
    if (quickActionsDiv.parentElement) {
      quickActionsDiv.style.opacity = '0.7';
    }
  }, 10000);
}

function initOB1CodespaceEnhancements() {
  // Add GitHub integration indicator
  addCodespaceGitHubIndicator();
  
  // Enhance codespace with additional OB-1 features
  addCodespaceFeatures();
}

function addCodespaceGitHubIndicator() {
  if (document.getElementById('ob1-github-indicator')) return;
  
  const indicator = document.createElement('div');
  indicator.id = 'ob1-github-indicator';
  indicator.innerHTML = `
    <div style="
      position: fixed;
      top: 10px;
      left: 10px;
      background: linear-gradient(45deg, #00d4ff, #0ea5e9);
      color: black;
      padding: 8px 16px;
      border-radius: 20px;
      font-size: 12px;
      font-weight: bold;
      z-index: 10000;
      display: flex;
      align-items: center;
      gap: 8px;
    ">
      <span>💻 GitHub Extension Connected</span>
      <button onclick="this.parentElement.remove()" style="
        background: rgba(0,0,0,0.2);
        border: none;
        border-radius: 50%;
        width: 20px;
        height: 20px;
        font-size: 12px;
        cursor: pointer;
      ">×</button>
    </div>
  `;
  
  document.body.appendChild(indicator);
  
  // Auto-remove after 5 seconds
  setTimeout(() => {
    if (indicator.parentElement) {
      indicator.remove();
    }
  }, 5000);
}

function addCodespaceFeatures() {
  // Send message to background script about successful codespace connection
  chrome.runtime.sendMessage({
    type: 'UPDATE_BADGE',
    text: 'OB1'
  });
}

// Message listener for extension communication
chrome.runtime.onMessage.addListener((message, sender, sendResponse) => {
  console.log('Content script received message:', message);
  
  switch (message.type) {
    case 'INJECT_INTERFACE':
      // Re-inject interface if needed
      if (window.location.hostname === 'github.com') {
        addOB1RepositoryInsights();
        sendResponse({ success: true });
      }
      break;
      
    case 'GET_PAGE_INFO':
      sendResponse({
        url: window.location.href,
        title: document.title,
        isGitHub: window.location.hostname === 'github.com',
        isCodespace: window.location.hostname.includes('fictional-parakeet-4xg9xp9gq97h75wp-5000.app.github.dev')
      });
      break;
      
    default:
      sendResponse({ success: false, error: 'Unknown message type' });
  }
  
  return true;
});

// Auto-refresh extension state every 30 seconds
setInterval(() => {
  if (window.location.hostname === 'github.com') {
    // Re-check for OB-1 repository updates
    if (isOB1Repository() && !document.getElementById('ob1-repo-insights')) {
      addOB1RepositoryInsights();
    }
  }
}, 30000);