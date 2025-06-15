#!/usr/bin/env node

import { Server } from '@modelcontextprotocol/sdk/server/index.js';
import { StdioServerTransport } from '@modelcontextprotocol/sdk/server/stdio.js';
import {
  CallToolRequestSchema,
  ErrorCode,
  ListToolsRequestSchema,
  McpError,
} from '@modelcontextprotocol/sdk/types.js';
import { BlockchainTools } from './tools/blockchain.js';
import { DevelopmentTools } from './tools/development.js';
import { GitHubTools } from './tools/github.js';
import { AITools } from './tools/ai.js';
import { CopilotIntegration } from './integrations/copilot.js';

/**
 * OB-1 <-> GitHub Copilot MCP Server
 * 
 * This server provides a bridge between OB-1's blockchain capabilities
 * and GitHub Copilot's AI assistance, enabling seamless collaboration
 * between AI agents for enhanced development workflows.
 */
class OB1CopilotMCPServer {
  private server: Server;
  private blockchainTools: BlockchainTools;
  private developmentTools: DevelopmentTools;
  private githubTools: GitHubTools;
  private aiTools: AITools;
  private copilotIntegration: CopilotIntegration;

  constructor() {
    this.server = new Server(
      {
        name: 'ob1-copilot-mcp-server',
        version: '1.0.0',
      },
      {
        capabilities: {
          tools: {},
          resources: {},
          prompts: {},
        },
      }
    );

    // Initialize tool categories
    this.blockchainTools = new BlockchainTools();
    this.developmentTools = new DevelopmentTools();
    this.githubTools = new GitHubTools();
    this.aiTools = new AITools();
    this.copilotIntegration = new CopilotIntegration();

    this.setupHandlers();
  }

  private setupHandlers() {
    // List available tools
    this.server.setRequestHandler(ListToolsRequestSchema, async () => {
      const tools = [
        // Blockchain Tools
        {
          name: 'blockchain_query',
          description: 'Execute blockchain queries and fetch on-chain data',
          inputSchema: {
            type: 'object',
            properties: {
              action: { type: 'string', enum: ['rpc', 'sql', 'cryo', 'market_data'] },
              params: { type: 'object' },
              chain: { type: 'string', default: 'ethereum' }
            },
            required: ['action', 'params']
          }
        },
        
        // Development Tools
        {
          name: 'development_execute',
          description: 'Execute development tasks, code analysis, and deployments',
          inputSchema: {
            type: 'object',
            properties: {
              task: { type: 'string', enum: ['python', 'deploy', 'test', 'analyze'] },
              code: { type: 'string' },
              params: { type: 'object' }
            },
            required: ['task']
          }
        },
        
        // GitHub Integration
        {
          name: 'github_operation',
          description: 'Perform GitHub operations and repository management',
          inputSchema: {
            type: 'object',
            properties: {
              operation: { type: 'string', enum: ['create_repo', 'push_files', 'create_pr', 'search'] },
              params: { type: 'object' }
            },
            required: ['operation', 'params']
          }
        },
        
        // AI Collaboration
        {
          name: 'ai_collaborate',
          description: 'Collaborate with AI agents and reasoning systems',
          inputSchema: {
            type: 'object',
            properties: {
              action: { type: 'string', enum: ['consult', 'reason', 'ask_human'] },
              context: { type: 'string' },
              question: { type: 'string' }
            },
            required: ['action']
          }
        },
        
        // Copilot Bridge
        {
          name: 'copilot_bridge',
          description: 'Bridge OB-1 capabilities with GitHub Copilot',
          inputSchema: {
            type: 'object',
            properties: {
              bridge_action: { type: 'string', enum: ['sync_context', 'share_insights', 'collaborative_code'] },
              data: { type: 'object' },
              copilot_context: { type: 'string' }
            },
            required: ['bridge_action']
          }
        }
      ];

      return { tools };
    });

    // Handle tool calls
    this.server.setRequestHandler(CallToolRequestSchema, async (request) => {
      const { name, arguments: args } = request.params;

      try {
        let result;
        
        switch (name) {
          case 'blockchain_query':
            result = await this.blockchainTools.execute(args);
            break;
            
          case 'development_execute':
            result = await this.developmentTools.execute(args);
            break;
            
          case 'github_operation':
            result = await this.githubTools.execute(args);
            break;
            
          case 'ai_collaborate':
            result = await this.aiTools.execute(args);
            break;
            
          case 'copilot_bridge':
            result = await this.copilotIntegration.execute(args);
            break;
            
          default:
            throw new McpError(ErrorCode.MethodNotFound, `Tool ${name} not found`);
        }

        return {
          content: [
            {
              type: 'text',
              text: JSON.stringify(result, null, 2)
            }
          ]
        };
      } catch (error) {
        const errorMessage = error instanceof Error ? error.message : String(error);
        throw new McpError(ErrorCode.InternalError, `Tool execution failed: ${errorMessage}`);
      }
    });

    // Error handling
    this.server.onerror = (error) => {
      console.error('[MCP Server Error]', error);
    };

    process.on('SIGINT', async () => {
      await this.server.close();
      process.exit(0);
    });
  }

  async start() {
    const transport = new StdioServerTransport();
    await this.server.connect(transport);
    console.log('🚀 OB-1 <-> GitHub Copilot MCP Server started');
    console.log('📡 Ready for AI collaboration!');
  }
}

// Start the server
if (import.meta.url === `file://${process.argv[1]}`) {
  const server = new OB1CopilotMCPServer();
  server.start().catch(console.error);
}

export { OB1CopilotMCPServer };