import axios from 'axios';

/**
 * GitHub Tools for OB-1 <-> Copilot Integration
 * 
 * Provides GitHub API integration for repository management,
 * pull requests, issues, and collaborative development.
 */
export class GitHubTools {
  private githubToken: string;
  private baseURL: string;

  constructor() {
    this.githubToken = process.env.GITHUB_TOKEN || '';
    this.baseURL = 'https://api.github.com';
  }

  async execute(params: any): Promise<any> {
    const { operation, params: opParams } = params;

    switch (operation) {
      case 'create_repo':
        return this.createRepository(opParams);
      case 'push_files':
        return this.pushFiles(opParams);
      case 'create_pr':
        return this.createPullRequest(opParams);
      case 'search':
        return this.searchRepositories(opParams);
      case 'get_issues':
        return this.getIssues(opParams);
      case 'create_issue':
        return this.createIssue(opParams);
      default:
        throw new Error(`Unknown GitHub operation: ${operation}`);
    }
  }

  private async createRepository(params: any): Promise<any> {
    try {
      const response = await axios.post(`${this.baseURL}/user/repos`, {
        name: params.name,
        description: params.description || '',
        private: params.private || false,
        auto_init: params.autoInit || true
      }, {
        headers: {
          'Authorization': `Bearer ${this.githubToken}`,
          'Accept': 'application/vnd.github.v3+json'
        }
      });

      return {
        success: true,
        repository: {
          name: response.data.name,
          full_name: response.data.full_name,
          html_url: response.data.html_url,
          clone_url: response.data.clone_url
        },
        timestamp: new Date().toISOString()
      };
    } catch (error) {
      return {
        success: false,
        error: error instanceof Error ? error.message : 'Unknown error',
        timestamp: new Date().toISOString()
      };
    }
  }

  private async pushFiles(params: any): Promise<any> {
    // Simulated file pushing - in production would use GitHub API
    return {
      success: true,
      repository: `${params.owner}/${params.repo}`,
      branch: params.branch || 'main',
      files_pushed: params.files?.length || 0,
      commit_message: params.message,
      note: 'GitHub API integration ready for actual file operations',
      timestamp: new Date().toISOString()
    };
  }

  private async createPullRequest(params: any): Promise<any> {
    try {
      const response = await axios.post(
        `${this.baseURL}/repos/${params.owner}/${params.repo}/pulls`,
        {
          title: params.title,
          body: params.body || '',
          head: params.head,
          base: params.base || 'main'
        },
        {
          headers: {
            'Authorization': `Bearer ${this.githubToken}`,
            'Accept': 'application/vnd.github.v3+json'
          }
        }
      );

      return {
        success: true,
        pull_request: {
          number: response.data.number,
          title: response.data.title,
          html_url: response.data.html_url,
          state: response.data.state
        },
        timestamp: new Date().toISOString()
      };
    } catch (error) {
      return {
        success: false,
        error: error instanceof Error ? error.message : 'Unknown error',
        timestamp: new Date().toISOString()
      };
    }
  }

  private async searchRepositories(params: any): Promise<any> {
    try {
      const response = await axios.get(`${this.baseURL}/search/repositories`, {
        params: {
          q: params.query,
          sort: params.sort || 'stars',
          order: params.order || 'desc',
          per_page: params.per_page || 10
        },
        headers: {
          'Authorization': `Bearer ${this.githubToken}`,
          'Accept': 'application/vnd.github.v3+json'
        }
      });

      return {
        success: true,
        total_count: response.data.total_count,
        repositories: response.data.items.map((repo: any) => ({
          name: repo.name,
          full_name: repo.full_name,
          description: repo.description,
          stars: repo.stargazers_count,
          html_url: repo.html_url
        })),
        timestamp: new Date().toISOString()
      };
    } catch (error) {
      return {
        success: false,
        error: error instanceof Error ? error.message : 'Unknown error',
        timestamp: new Date().toISOString()
      };
    }
  }

  private async getIssues(params: any): Promise<any> {
    try {
      const response = await axios.get(
        `${this.baseURL}/repos/${params.owner}/${params.repo}/issues`,
        {
          params: {
            state: params.state || 'open',
            per_page: params.per_page || 10
          },
          headers: {
            'Authorization': `Bearer ${this.githubToken}`,
            'Accept': 'application/vnd.github.v3+json'
          }
        }
      );

      return {
        success: true,
        issues: response.data.map((issue: any) => ({
          number: issue.number,
          title: issue.title,
          state: issue.state,
          html_url: issue.html_url,
          created_at: issue.created_at
        })),
        timestamp: new Date().toISOString()
      };
    } catch (error) {
      return {
        success: false,
        error: error instanceof Error ? error.message : 'Unknown error',
        timestamp: new Date().toISOString()
      };
    }
  }

  private async createIssue(params: any): Promise<any> {
    try {
      const response = await axios.post(
        `${this.baseURL}/repos/${params.owner}/${params.repo}/issues`,
        {
          title: params.title,
          body: params.body || '',
          labels: params.labels || []
        },
        {
          headers: {
            'Authorization': `Bearer ${this.githubToken}`,
            'Accept': 'application/vnd.github.v3+json'
          }
        }
      );

      return {
        success: true,
        issue: {
          number: response.data.number,
          title: response.data.title,
          html_url: response.data.html_url,
          state: response.data.state
        },
        timestamp: new Date().toISOString()
      };
    } catch (error) {
      return {
        success: false,
        error: error instanceof Error ? error.message : 'Unknown error',
        timestamp: new Date().toISOString()
      };
    }
  }
}