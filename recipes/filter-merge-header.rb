# frozen_string_literal: true

#
# Cookbook Name:: repose
# Recipe:: filter-merge-header
#
# Copyright (C) 2016 Rackspace Hosting
#

unless node['repose']['filters'].include? 'merge-header'
  filters = node['repose']['filters'] + ['merge-header']
  node.normal['repose']['filters'] = filters
end

template "#{node['repose']['config_directory']}/merge-header.cfg.xml" do
  owner node['repose']['owner']
  group node['repose']['group']
  mode '0644'
  variables(
    response_headers: node['repose']['merge_header']['response_headers'],
    request_headers: node['repose']['merge_header']['request_headers']
  )
  notifies :restart, 'service[repose-valve]'
end
