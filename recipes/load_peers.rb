#
# Cookbook Name:: repose
# Recipe:: load_peers
#
# Copyright (C) 2013 Rackspace Hosting
#

if node['repose']['peer_search_enabled']

  search_role = node['repose']['peer_search_role']
  search_cluster_id = node['repose']['cluster_id']
  search_env = node.chef_environment || '_default'

  found_nodes = []
  if Chef::Config[:solo]
    log 'Chef search disabled'
  else
    found_nodes = search 'node', node['repose']['peer_search_query']
    log 'Chef search results' do
      message "Search for \"#{node['repose']['peer_search_query']}\" yields \"#{found_nodes}\""
    end
  end

  peers = RackHelpers::Repose.peers found_nodes
  peers.flatten!
  peers.sort!{ |a,b| a['id'] <=> b['id'] }

  node.normal['repose']['peers'] = peers

end
