# frozen_string_literal: true

#
# Cookbook Name:: repose
# Recipe:: filter-header-normalization
#
# Copyright (C) 2013 Rackspace Hosting
#

unless node['repose']['filters'].include? 'header-normalization'
  filters = node['repose']['filters'] + ['header-normalization']
  node.normal['repose']['filters'] = filters
end

template "#{node['repose']['config_directory']}/header-normalization.cfg.xml" do
  owner node['repose']['owner']
  group node['repose']['group']
  mode '0644'
  variables(
    whitelist: node['repose']['header_normalization']['whitelist'],
    blacklist: node['repose']['header_normalization']['blacklist']
  )
  notifies :restart, 'service[repose-valve]'
end
