#
# Cookbook Name:: repose
# Recipe:: load_peers
#
# Copyright (C) 2013 Rackspace Hosting
#
# All rights reserved - Do Not Redistribute
#

if node['repose']['peer_search_enabled']

  search_role = node['repose']['peer_search_role']
  search_cluster_id = node['repose']['cluster_id']
  search_env = node.chef_environment || '_default'

  found_nodes = []
  if Chef::Config[:solo]
    log 'Chef search disabled'
  else
    search_query = "roles:#{search_role} AND chef_environment:#{search_env} AND repose_cluster_id:#{search_cluster_id}"
    found_nodes = search 'node', search_query
    log 'Chef search results' do
      message "Search for \"#{search_query}\" yields \"#{found_nodes}\""
    end
  end

  peers = RackHelpers::Repose.peers found_nodes
  peers.sort!{ |a,b| a['id'] <=> b['id'] }

  node.normal['repose']['peers'] = peers

end
