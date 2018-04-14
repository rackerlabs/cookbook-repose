# frozen_string_literal: true

#
# Cookbook Name:: repose
# Recipe:: filter-header-identity
#
# Copyright (C) 2014 Rackspace Hosting
#

unless node['repose']['filters'].include? 'header-identity'
  filters = node['repose']['filters'] + ['header-identity']
  node.normal['repose']['filters'] = filters
end

template "#{node['repose']['config_directory']}/header-identity.cfg.xml" do
  owner node['repose']['owner']
  group node['repose']['group']
  mode '0644'
  variables(
    headers: node['repose']['header_identity']['headers']
  )
  notifies :restart, 'service[repose-valve]'
end
