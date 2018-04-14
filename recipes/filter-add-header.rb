# frozen_string_literal: true

#
# Cookbook Name:: repose
# Recipe:: filter-add-header
#
# Copyright (C) 2015 Rackspace Hosting
#

unless node['repose']['filters'].include? 'add-header'
  filters = node['repose']['filters'] + ['add-header']
  node.normal['repose']['filters'] = filters
end

template "#{node['repose']['config_directory']}/add-header.cfg.xml" do
  owner node['repose']['owner']
  group node['repose']['group']
  mode '0644'
  notifies :restart, 'service[repose-valve]'
  variables(
    requests: node['repose']['add_header']['requests'],
    responses: node['repose']['add_header']['responses'],
    version: node['repose']['version']
  )
end
