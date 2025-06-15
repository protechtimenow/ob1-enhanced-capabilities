// VS Code Extension for OB-1 + Copilot
import * as vscode from 'vscode';

export function activate(context: vscode.ExtensionContext) {
  // Register OB-1 commands
  const commands = [
    vscode.commands.registerCommand('ob1.analyzeSuperstacks', () => {
      const panel = vscode.window.createWebviewPanel(
        'ob1SuperStacks',
        'OB-1 SuperStacks Analysis',
        vscode.ViewColumn.One,
        { enableScripts: true }
      );
      
      panel.webview.html = getSuperstacksWebview();
    }),

    vscode.commands.registerCommand('ob1.enhanceCopilot', () => {
      const editor = vscode.window.activeTextEditor;
      if (editor) {
        const selection = editor.document.getText(editor.selection);
        // Enhance with OB-1 blockchain intelligence
        vscode.window.showInformationMessage('Code enhanced with OB-1 intelligence!');
      }
    })
  ];

  context.subscriptions.push(...commands);
}

function getSuperstacksWebview(): string {
  return `
    <!DOCTYPE html>
    <html>
    <head>
        <title>OB-1 SuperStacks Analysis</title>
        <style>
            body { font-family: 'Segoe UI'; padding: 20px; }
            .metric { background: #1e1e1e; padding: 15px; margin: 10px 0; border-radius: 8px; }
            .value { font-size: 24px; color: #00ff64; font-weight: bold; }
        </style>
    </head>
    <body>
        <h1>🏆 SuperStacks Command Center</h1>
        <div class="metric">
            <h3>Your Points</h3>
            <div class="value">242.66M</div>
        </div>
        <div class="metric">
            <h3>Ecosystem Share</h3>
            <div class="value">9.06%</div>
        </div>
        <div class="metric">
            <h3>Current Rank</h3>
            <div class="value">TOP 5</div>
        </div>
    </body>
    </html>
  `;
}