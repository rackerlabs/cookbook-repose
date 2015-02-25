#
# Cookbook Name:: repose
# Recipe:: service-connection-pool
#
# Copyright (C) 2014 Rackspace Hosting
#

template "#{node['repose']['config_directory']}/http-connection-pool.cfg.xml" do
  owner node['repose']['owner']
  group node['repose']['group']
  mode '0644'
  variables(
    chunked_encoding: node['repose']['connection_pool']['chunked_encoding'],
    max_total: node['repose']['connection_pool']['max_total'],
    max_per_route: node['repose']['connection_pool']['max_per_route'],
    socket_timeout: node['repose']['connection_pool']['socket_timeout'],
    connection_timeout: node['repose']['connection_pool']['connection_timeout'],
    socket_buffer_size: node['repose']['connection_pool']['socket_buffer_size'],
    connection_max_line_length: node['repose']['connection_pool']['connection_max_line_length'],
    connection_max_header_count: node['repose']['connection_pool']['connection_max_header_count'],
    connection_max_status_line_garbage: node['repose']['connection_pool']['connection_max_status_line_garbage'],
    tcp_nodelay: node['repose']['connection_pool']['tcp_nodelay'],
    keepalive_timeout: node['repose']['connection_pool']['keepalive_timeout']
  )
  notifies :restart, 'service[repose-valve]'
end
