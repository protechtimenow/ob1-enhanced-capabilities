// OB-1 Background Service Worker

// Extension installation handler
chrome.runtime.onInstalled.addListener((details) => {
  console.log('OB-1 Extension installed:', details.reason);
  
  if (details.reason === 'install') {
    // Set initial badge
    chrome.action.setBadgeText({ text: 'OB1' });
    chrome.action.setBadgeBackgroundColor({ color: '#00ff64' });
    
    // Open welcome page
    chrome.tabs.create({
      url: 'https://fictional-parakeet-4xg9xp9gq97h75wp-5000.app.github.dev'
    });
  }
});

// Handle extension icon clicks
chrome.action.onClicked.addListener((tab) => {
  // This is handled by popup.html, but we can add fallback logic here
  console.log('OB-1 Extension clicked on tab:', tab.url);
});

// Message handling from content scripts
chrome.runtime.onMessage.addListener((message, sender, sendResponse) => {
  console.log('Background received message:', message);
  
  switch (message.type) {
    case 'INJECT_OB1':
      handleInjectOB1(sender.tab.id);
      sendResponse({ success: true });
      break;
      
    case 'UPDATE_BADGE':
      chrome.action.setBadgeText({ 
        text: message.text,
        tabId: sender.tab.id 
      });
      sendResponse({ success: true });
      break;
      
    case 'OPEN_DASHBOARD':
      chrome.tabs.create({
        url: 'https://fictional-parakeet-4xg9xp9gq97h75wp-5000.app.github.dev'
      });
      sendResponse({ success: true });
      break;
      
    default:
      sendResponse({ success: false, error: 'Unknown message type' });
  }
  
  return true; // Keep message channel open for async response
});

// Inject OB-1 interface into GitHub pages
async function handleInjectOB1(tabId) {
  try {
    await chrome.scripting.executeScript({
      target: { tabId },
      func: injectOB1Interface
    });
    
    console.log('OB-1 interface injected successfully');
  } catch (error) {
    console.error('Failed to inject OB-1 interface:', error);
  }
}

// Function to be injected into pages
function injectOB1Interface() {
  // Prevent multiple injections
  if (document.getElementById('ob1-floating-interface')) {
    return;
  }
  
  // Create floating OB-1 interface
  const ob1Float = document.createElement('div');
  ob1Float.id = 'ob1-floating-interface';
  ob1Float.innerHTML = `
    <div id="ob1-minimized" style="
      position: fixed;
      bottom: 20px;
      right: 20px;
      width: 60px;
      height: 60px;
      background: linear-gradient(45deg, #00ff64, #00d4aa);
      border-radius: 50%;
      display: flex;
      align-items: center;
      justify-content: center;
      cursor: pointer;
      z-index: 10000;
      box-shadow: 0 5px 20px rgba(0,255,100,0.4);
      transition: all 0.3s ease;
      font-size: 24px;
    ">
      🚀
    </div>
    
    <div id="ob1-expanded" style="
      position: fixed;
      bottom: 20px;
      right: 20px;
      width: 320px;
      background: linear-gradient(135deg, #0a0a0f, #1a1a2e);
      color: white;
      padding: 20px;
      border-radius: 15px;
      border: 2px solid #00ff64;
      box-shadow: 0 10px 30px rgba(0,0,0,0.7);
      z-index: 10001;
      font-family: 'Segoe UI', sans-serif;
      display: none;
    ">
      <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 15px;">
        <h3 style="margin: 0; color: #00ff64;">🚀 OB-1 Command Center</h3>
        <button id="ob1-minimize" style="
          background: none;
          border: none;
          color: white;
          font-size: 18px;
          cursor: pointer;
          opacity: 0.7;
        ">✕</button>
      </div>
      
      <div style="margin-bottom: 15px;">
        <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 10px; margin-bottom: 15px;">
          <div style="background: rgba(255,255,255,0.05); padding: 10px; border-radius: 8px; text-align: center;">
            <div style="color: #00ff64; font-size: 16px; font-weight: bold;">242.7M</div>
            <div style="font-size: 11px; opacity: 0.8;">Total Points</div>
          </div>
          <div style="background: rgba(255,255,255,0.05); padding: 10px; border-radius: 8px; text-align: center;">
            <div style="color: #00ff64; font-size: 16px; font-weight: bold;">9.06%</div>
            <div style="font-size: 11px; opacity: 0.8;">Ecosystem Share</div>
          </div>
        </div>
        
        <div style="background: rgba(0,255,100,0.1); padding: 12px; border-radius: 8px; border-left: 4px solid #00ff64;">
          <div style="font-size: 12px; margin-bottom: 4px;">Status: <strong style="color: #00ff64;">QUANTUM OPTIMAL</strong></div>
          <div style="font-size: 11px; opacity: 0.8;">Perfect positioning in Unichain + Uniswap V4</div>
        </div>
      </div>
      
      <div style="display: flex; flex-direction: column; gap: 8px;">
        <button onclick="window.open('https://fictional-parakeet-4xg9xp9gq97h75wp-5000.app.github.dev', '_blank')" style="
          width: 100%;
          padding: 12px;
          background: linear-gradient(45deg, #00ff64, #00d4aa);
          border: none;
          border-radius: 8px;
          color: black;
          font-weight: bold;
          cursor: pointer;
        ">📊 Open Full Dashboard</button>
        
        <button onclick="window.open('https://github.com/protechtimenow/ob1-enhanced-capabilities', '_blank')" style="
          width: 100%;
          padding: 10px;
          background: linear-gradient(45deg, #00d4ff, #0ea5e9);
          border: none;
          border-radius: 8px;
          color: black;
          font-weight: bold;
          cursor: pointer;
        ">💻 GitHub Codespace</button>
        
        <button id="ob1-quantum-pulse" style="
          width: 100%;
          padding: 10px;
          background: linear-gradient(45deg, #7c3aed, #a855f7);
          border: none;
          border-radius: 8px;
          color: white;
          font-weight: bold;
          cursor: pointer;
        ">⚡ Quantum Pulse</button>
      </div>
    </div>
  `;
  
  document.body.appendChild(ob1Float);
  
  // Event handlers
  const minimized = document.getElementById('ob1-minimized');
  const expanded = document.getElementById('ob1-expanded');
  const minimizeBtn = document.getElementById('ob1-minimize');
  const quantumBtn = document.getElementById('ob1-quantum-pulse');
  
  minimized.addEventListener('click', () => {
    minimized.style.display = 'none';
    expanded.style.display = 'block';
  });
  
  minimizeBtn.addEventListener('click', () => {
    expanded.style.display = 'none';
    minimized.style.display = 'flex';
  });
  
  quantumBtn.addEventListener('click', () => {
    quantumBtn.style.background = 'linear-gradient(45deg, #ff6b6b, #feca57)';
    quantumBtn.textContent = '⚡ Quantum Active!';
    
    // Add quantum effect to page
    document.body.style.filter = 'hue-rotate(180deg)';
    
    setTimeout(() => {
      document.body.style.filter = '';
      quantumBtn.style.background = 'linear-gradient(45deg, #7c3aed, #a855f7)';
      quantumBtn.textContent = '⚡ Quantum Pulse';
    }, 2000);
  });
  
  // Auto-show expanded for 5 seconds on first load
  minimized.style.display = 'none';
  expanded.style.display = 'block';
  
  setTimeout(() => {
    if (expanded.style.display === 'block') {
      expanded.style.display = 'none';
      minimized.style.display = 'flex';
    }
  }, 5000);
}

// Tab change detection for badge updates
chrome.tabs.onActivated.addListener(async (activeInfo) => {
  const tab = await chrome.tabs.get(activeInfo.tabId);
  
  if (tab.url && tab.url.includes('github.com')) {
    chrome.action.setBadgeText({ text: 'GIT', tabId: tab.id });
    chrome.action.setBadgeBackgroundColor({ color: '#00d4ff' });
  } else if (tab.url && tab.url.includes('fictional-parakeet-4xg9xp9gq97h75wp-5000.app.github.dev')) {
    chrome.action.setBadgeText({ text: 'OB1', tabId: tab.id });
    chrome.action.setBadgeBackgroundColor({ color: '#00ff64' });
  } else {
    chrome.action.setBadgeText({ text: '' });
  }
});

// Periodic connection check to OB-1 dashboard
setInterval(async () => {
  try {
    const response = await fetch('https://fictional-parakeet-4xg9xp9gq97h75wp-5000.app.github.dev/health');
    
    if (response.ok) {
      chrome.action.setBadgeBackgroundColor({ color: '#00ff64' });
    } else {
      chrome.action.setBadgeBackgroundColor({ color: '#ff4444' });
    }
  } catch (error) {
    chrome.action.setBadgeBackgroundColor({ color: '#ff4444' });
  }
}, 30000); // Check every 30 seconds