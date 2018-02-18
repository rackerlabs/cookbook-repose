# frozen_string_literal: true

#
# Cookbook Name:: repose
# Recipe:: filter-rackspace-auth-user
#
# Copyright (C) 2014 Rackspace Hosting
#

unless node['repose']['filters'].include? 'rackspace-auth-user'
  filters = node['repose']['filters'] + ['rackspace-auth-user']
  node.normal['repose']['filters'] = filters
end

template "#{node['repose']['config_directory']}/rackspace-auth-user.cfg.xml" do
  owner node['repose']['owner']
  group node['repose']['group']
  mode '0644'
  variables(
    v1_1: node['repose']['rackspace_auth_user']['v1_1'],
    v2_0: node['repose']['rackspace_auth_user']['v2_0'],
    version: node['repose']['version']
  )
  notifies :restart, 'service[repose-valve]'
end
