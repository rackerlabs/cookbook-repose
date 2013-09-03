#
# Cookbook Name:: repose
# Recipe:: filter-dist-datastore
#
# Copyright (C) 2013 Rackspace Hosting
#
# All rights reserved - Do Not Redistribute
#

include_recipe 'repose::install'

unless node['repose']['filters'].include? 'dist-datastore'
  filters = node['repose']['filters'] + ['dist-datastore']
  node.normal['repose']['filters'] = filters
end

template '/etc/repose/dist-datastore.cfg.xml' do
  owner 'repose'
  group 'repose'
  mode '0644'
  variables(
    :allow_all => node['repose']['dist_datastore']['allow_all'],
    :allowed_hosts => node['repose']['dist_datastore']['allowed_hosts']
  )
  notifies :restart, 'service[repose-valve]'
end
