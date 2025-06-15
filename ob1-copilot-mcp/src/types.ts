// TypeScript definitions for OB-1 + Copilot integration
export interface SuperStacksPosition {
  wallet: string;
  total_points: string;
  ecosystem_share: string;
  rank: string;
  chains: Record<string, string>;
  protocols: Record<string, string>;
}

export interface BlockchainQuery {
  chain_id: number;
  query_type: "balance" | "transactions" | "tokens" | "defi" | "nft";
  address?: string;
}

export interface DashboardConfig {
  dashboard_type: "portfolio" | "defi" | "superstacks" | "analytics";
  framework: "react" | "vue" | "svelte" | "html";
}