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
    :max_total => node['repose']['connection_pool']['max_total'],
    :max_per_route => node['repose']['connection_pool']['max_per_route'],
    :socket_timeout => node['repose']['connection_pool']['socket_timeout'],
    :connection_timeout => node['repose']['connection_pool']['connection_timeout']
  )
  notifies :restart, 'service[repose-valve]'
end
