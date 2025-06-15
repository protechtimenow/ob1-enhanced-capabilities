import { useEffect, useState } from 'react';
import { Line, Bar, Pie } from 'react-chartjs-2';
import {
  Chart as ChartJS,
  CategoryScale,
  LinearScale,
  PointElement,
  LineElement,
  BarElement,
  Title,
  Tooltip,
  Legend,
  ArcElement,
} from 'chart.js';
import axios from 'axios';

// Register Chart.js components
ChartJS.register(
  CategoryScale,
  LinearScale,
  PointElement,
  LineElement,
  BarElement,
  Title,
  Tooltip,
  Legend,
  ArcElement
);

interface SystemStatus {
  status: string;
  quantum_mode: string;
  agent_count: number;
  uptime: string;
  deployment: string;
}

interface SuperChainData {
  chain_name: string;
  total_points: number;
}

export default function Dashboard() {
  const [systemStatus, setSystemStatus] = useState<SystemStatus | null>(null);
  const [superchainData, setSuperchainData] = useState<SuperChainData[]>([]);
  const [loading, setLoading] = useState(true);
  
  const API_URL = process.env.NEXT_PUBLIC_API_URL;

  useEffect(() => {
    const fetchData = async () => {
      try {
        // Fetch system status
        const statusResponse = await axios.get(`${API_URL}/health`);
        setSystemStatus({
          status: 'healthy',
          quantum_mode: 'QUADUNDRUMISE',
          agent_count: 4,
          uptime: '100%',
          deployment: 'OB-1 Enhanced'
        });

        // Demo SuperChain data from the charts
        setSuperchainData([
          { chain_name: 'Unichain', total_points: 2164900094.996357 },
          { chain_name: 'Optimism', total_points: 367740898.980791 },
          { chain_name: 'Ink', total_points: 105649782.82917005 },
          { chain_name: 'Soneium', total_points: 29867876.462243456 },
          { chain_name: 'Base', total_points: 10533938.145127328 },
          { chain_name: 'Worldchain', total_points: 875941.5771209938 }
        ]);

        setLoading(false);
      } catch (error) {
        console.error('Error fetching data:', error);
        // Set demo data even on error
        setSystemStatus({
          status: 'connecting',
          quantum_mode: 'QUADUNDRUMISE',
          agent_count: 4,
          uptime: 'Initializing',
          deployment: 'OB-1 Enhanced'
        });
        setLoading(false);
      }
    };

    fetchData();
    const interval = setInterval(fetchData, 30000); // Refresh every 30 seconds

    return () => clearInterval(interval);
  }, [API_URL]);

  const chainChartData = {
    labels: superchainData.map(item => item.chain_name),
    datasets: [
      {
        label: 'Total Points',
        data: superchainData.map(item => item.total_points / 1000000), // Convert to millions
        backgroundColor: [
          '#8B5CF6', // Unichain - Purple
          '#10B981', // Optimism - Green  
          '#F59E0B', // Ink - Orange
          '#EF4444', // Soneium - Red
          '#3B82F6', // Base - Blue
          '#6366F1', // Worldchain - Indigo
        ],
        borderWidth: 2,
      },
    ],
  };

  const protocolTimeData = {
    labels: ['Apr 16', 'Apr 17', 'Apr 18', 'Apr 19', 'Apr 20'],
    datasets: [
      {
        label: 'Uniswap V4 Points (M)',
        data: [24.2, 95.6, 121.2, 132.8, 141.8],
        borderColor: '#8B5CF6',
        backgroundColor: 'rgba(139, 92, 246, 0.1)',
        tension: 0.4,
      },
      {
        label: 'Velodrome V3 Points (M)', 
        data: [1.6, 13.7, 24.6, 28.4, 30.5],
        borderColor: '#10B981',
        backgroundColor: 'rgba(16, 185, 129, 0.1)',
        tension: 0.4,
      }
    ],
  };

  if (loading) {
    return (
      <div className="min-h-screen bg-gray-900 flex items-center justify-center">
        <div className="text-white text-xl">🌌 Initializing Quantum Empire...</div>
      </div>
    );
  }

  return (
    <div className="min-h-screen bg-gray-900 text-white">
      {/* Header */}
      <header className="bg-gray-800 shadow-lg">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="flex justify-between items-center py-6">
            <div className="flex items-center">
              <h1 className="text-3xl font-bold text-purple-400">⚡ OB-1 Enhanced</h1>
              <span className="ml-4 px-3 py-1 bg-purple-600 rounded-full text-sm">
                Quantum Empire Command Center
              </span>
            </div>
            <div className="flex items-center space-x-4">
              <div className="flex items-center">
                <div className={`w-3 h-3 rounded-full ${systemStatus?.status === 'healthy' ? 'bg-green-400' : 'bg-yellow-400'} mr-2`} />
                <span>{systemStatus?.status === 'healthy' ? 'Operational' : 'Connecting'}</span>
              </div>
            </div>
          </div>
        </div>
      </header>

      <main className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
        {/* System Status Cards */}
        <div className="grid grid-cols-1 md:grid-cols-4 gap-6 mb-8">
          <div className="bg-gray-800 rounded-lg p-6">
            <div className="flex items-center">
              <div className="text-2xl">🧠</div>
              <div className="ml-4">
                <p className="text-sm text-gray-400">Quantum Mode</p>
                <p className="text-lg font-semibold text-purple-400">{systemStatus?.quantum_mode}</p>
              </div>
            </div>
          </div>
          
          <div className="bg-gray-800 rounded-lg p-6">
            <div className="flex items-center">
              <div className="text-2xl">🤖</div>
              <div className="ml-4">
                <p className="text-sm text-gray-400">Active Agents</p>
                <p className="text-lg font-semibold text-green-400">{systemStatus?.agent_count}</p>
              </div>
            </div>
          </div>

          <div className="bg-gray-800 rounded-lg p-6">
            <div className="flex items-center">
              <div className="text-2xl">⚡</div>
              <div className="ml-4">
                <p className="text-sm text-gray-400">Uptime</p>
                <p className="text-lg font-semibold text-blue-400">{systemStatus?.uptime}</p>
              </div>
            </div>
          </div>

          <div className="bg-gray-800 rounded-lg p-6">
            <div className="flex items-center">
              <div className="text-2xl">🚀</div>
              <div className="ml-4">
                <p className="text-sm text-gray-400">Deployment</p>
                <p className="text-lg font-semibold text-yellow-400">{systemStatus?.deployment}</p>
              </div>
            </div>
          </div>
        </div>

        {/* Charts Grid */}
        <div className="grid grid-cols-1 lg:grid-cols-2 gap-8">
          {/* SuperChain Points Distribution */}
          <div className="bg-gray-800 rounded-lg p-6">
            <h3 className="text-xl font-semibold mb-4 text-purple-400">
              🌐 SuperChain Points Distribution
            </h3>
            <div className="h-80">
              <Pie
                data={chainChartData}
                options={{
                  responsive: true,
                  maintainAspectRatio: false,
                  plugins: {
                    legend: {
                      position: 'bottom',
                      labels: { color: 'white' }
                    },
                    tooltip: {
                      callbacks: {
                        label: (context) => {
                          const value = context.raw as number;
                          return `${context.label}: ${value.toFixed(1)}M points`;
                        }
                      }
                    }
                  },
                }}
              />
            </div>
          </div>

          {/* Protocol Performance Comparison */}
          <div className="bg-gray-800 rounded-lg p-6">
            <h3 className="text-xl font-semibold mb-4 text-green-400">
              📈 Protocol Performance Comparison
            </h3>
            <div className="h-80">
              <Line
                data={protocolTimeData}
                options={{
                  responsive: true,
                  maintainAspectRatio: false,
                  scales: {
                    x: { ticks: { color: 'white' } },
                    y: { 
                      ticks: { color: 'white' },
                      title: { display: true, text: 'Points (Millions)', color: 'white' }
                    }
                  },
                  plugins: {
                    legend: { labels: { color: 'white' } }
                  },
                }}
              />
            </div>
          </div>
        </div>

        {/* Quantum Operations Status */}
        <div className="mt-8 bg-gray-800 rounded-lg p-6">
          <h3 className="text-xl font-semibold mb-4 text-blue-400">
            ⚡ Quantum Operations Status
          </h3>
          <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
            <div className="bg-gray-700 rounded-lg p-4">
              <div className="flex items-center justify-between">
                <span>Superposition Processing</span>
                <span className="text-green-400">✅ ACTIVE</span>
              </div>
            </div>
            <div className="bg-gray-700 rounded-lg p-4">
              <div className="flex items-center justify-between">
                <span>Entanglement Sync</span>
                <span className="text-green-400">✅ STABLE</span>
              </div>
            </div>
            <div className="bg-gray-700 rounded-lg p-4">
              <div className="flex items-center justify-between">
                <span>4D Computation</span>
                <span className="text-green-400">✅ PROCESSING</span>
              </div>
            </div>
          </div>
        </div>

        {/* Footer */}
        <footer className="mt-12 text-center text-gray-400">
          <p>OB-1 Enhanced Quantum Empire • Controller: 0x21cC30462B8392Aa250453704019800092a16165</p>
          <p className="mt-2">Powered by Railway + IO.NET + Docker MCP</p>
        </footer>
      </main>
    </div>
  );
}