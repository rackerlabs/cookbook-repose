#
# Cookbook Name:: repose
# Recipe:: service-dist-datastore
#
# Copyright (C) 2013 Rackspace Hosting
#
# All rights reserved - Do Not Redistribute
#

include_recipe 'repose::install'

unless node['repose']['services'].include? 'dist-datastore'
  services = node['repose']['services'] + ['dist-datastore']
  node.normal['repose']['services'] = services
end

template '/etc/repose/dist-datastore.cfg.xml' do
  owner node['repose']['owner']
  group node['repose']['group']
  mode '0644'
  variables(
    :allow_all => node['repose']['dist_datastore']['allow_all'],
    :allowed_hosts => node['repose']['dist_datastore']['allowed_hosts'],
    :cluster_id => node['repose']['cluster_id'],
    :port => node['repose']['dist_datastore']['port']
  )
  notifies :restart, 'service[repose-valve]'
end
