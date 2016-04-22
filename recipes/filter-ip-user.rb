#
# Cookbook Name:: repose
# Recipe:: filter-ip-user
#
# Copyright (C) 2016 Rackspace Hosting
#

unless node['repose']['filters'].include? 'ip-user'
  filters = node['repose']['filters'] + ['ip-user']
  node.normal['repose']['filters'] = filters
end

template "#{node['repose']['config_directory']}/ip-user.cfg.xml" do
  owner node['repose']['owner']
  group node['repose']['group']
  mode '0644'
  variables(
    quality: node['repose']['ip_user']['quality'],
    white_list_quality: node['repose']['ip_user']['white_list_quality'],
    white_list_ip_addresses: node['repose']['ip_user']['white_list_ip_addresses']
  )
  notifies :restart, 'service[repose-valve]'
end
