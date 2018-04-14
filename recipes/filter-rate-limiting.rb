# frozen_string_literal: true

#
# Cookbook Name:: repose
# Recipe:: filter-rate-limiting
#
# Copyright (C) 2013 Rackspace Hosting
#

unless node['repose']['filters'].include? 'rate-limiting'
  filters = node['repose']['filters'] + ['rate-limiting']
  node.normal['repose']['filters'] = filters
end

template "#{node['repose']['config_directory']}/rate-limiting.cfg.xml" do
  owner node['repose']['owner']
  group node['repose']['group']
  mode '0644'
  variables(
    datastore: node['repose']['rate_limiting']['datastore'],
    datastore_warn_limit: node['repose']['rate_limiting']['datastore_warn_limit'],
    overlimit_429_responsecode: node['repose']['rate_limiting']['overlimit_429_responsecode'],
    use_capture_groups: node['repose']['rate_limiting']['use_capture_groups'],
    uri_regex: node['repose']['rate_limiting']['uri_regex'],
    global_limits: node['repose']['rate_limiting']['global_limits'],
    include_absolute_limits: node['repose']['rate_limiting']['include_absolute_limits'],
    limit_groups: node['repose']['rate_limiting']['limit_groups']
  )
  notifies :restart, 'service[repose-valve]'
end
