#
# Cookbook Name:: repose
# Recipe:: filter-rate-limiting
#
# Copyright (C) 2013 Rackspace Hosting
#

include_recipe 'repose::install'

unless node['repose']['filters'].include? 'rate-limiting'
  filters = node['repose']['filters'] + ['rate-limiting']
  node.normal['repose']['filters'] = filters
end

template "#{node['repose']['config_directory']}/rate-limiting.cfg.xml" do
  owner node['repose']['owner']
  group node['repose']['group']
  mode '0644'
  variables(
    uri_regex: node['repose']['rate_limiting']['uri_regex'],
    include_absolute_limits: node['repose']['rate_limiting']['include_absolute_limits'],
    limit_groups: node['repose']['rate_limiting']['limit_groups']
  )
  notifies :restart, 'service[repose-valve]'
end
