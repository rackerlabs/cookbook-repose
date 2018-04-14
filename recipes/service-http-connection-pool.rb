# frozen_string_literal: true

#
# Cookbook Name:: repose
# Recipe:: service-http-connection-pool
#
# Copyright (C) 2014 Rackspace Hosting
#

unless node['repose']['services'].include? 'http-connection-pool'
  services = node['repose']['services'] + ['http-connection-pool']
  node.normal['repose']['services'] = services
end

template "#{node['repose']['config_directory']}/http-connection-pool.cfg.xml" do
  owner node['repose']['owner']
  group node['repose']['group']
  mode '0644'
  variables(
    chunked_encoding: node['repose']['http_connection_pool']['chunked_encoding'],
    max_total: node['repose']['http_connection_pool']['max_total'],
    max_per_route: node['repose']['http_connection_pool']['max_per_route'],
    socket_timeout: node['repose']['http_connection_pool']['socket_timeout'],
    connection_timeout: node['repose']['http_connection_pool']['connection_timeout'],
    socket_buffer_size: node['repose']['http_connection_pool']['socket_buffer_size'],
    connection_max_line_length: node['repose']['http_connection_pool']['connection_max_line_length'],
    connection_max_header_count: node['repose']['http_connection_pool']['connection_max_header_count'],
    connection_max_status_line_garbage: node['repose']['http_connection_pool']['connection_max_status_line_garbage'],
    tcp_nodelay: node['repose']['http_connection_pool']['tcp_nodelay'],
    keepalive_timeout: node['repose']['http_connection_pool']['keepalive_timeout']
  )
  notifies :restart, 'service[repose-valve]'
end
