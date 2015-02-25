class Chef
  module RackHelpers
    module Repose
      class << self
        def peers(nodes)
          nodes = [nodes] if nodes.class == Chef::Node
          nodes.map { |node| node_to_peer(node) }
        end

        def node_to_peer(node)
          if node['repose']['cluster_id'].nil?
            cluster_ids = node['repose']['cluster_ids']
          else
            cluster_ids = [node['repose']['cluster_id']]
          end

          cluster_ids.to_a.map.with_index do |cluster_id, i|
            { 'cluster_id'  => cluster_id,
              'id'          => node['repose']['node_id'],
              'hostname'    => node['fqdn'],
              'ipaddress'   => node['ipaddress'],
              'port'        => i + node['repose']['port'].to_i,
              'ssl_port'    => i + node['repose']['ssl_port'].to_i
            }
          end
        end
      end
    end
  end
end
