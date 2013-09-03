class Chef
  module RackHelpers
    module Repose
      class << self

        def peers(nodes)
          nodes = [nodes] if nodes.class == Chef::Node
          nodes.map{ |node| node_to_peer(node) }
        end

        def node_to_peer(node)
          { 'id'        => node['repose']['node_id'],
            'hostname'  => node['fqdn'],
            'ipaddress' => node['ipaddress'],
            'port'      => node['repose']['port'],
            'ssl_port'  => node['repose']['ssl_port']
          }
        end

      end
    end
  end
end
