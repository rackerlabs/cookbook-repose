# frozen_string_literal: true

#
# Cookbook Name:: repose
# Recipe:: filter-uri-identity
#
# Copyright (C) 2014 Rackspace Hosting
#

unless node['repose']['filters'].include? 'uri-identity'
  filters = node['repose']['filters'] + ['uri-identity']
  node.normal['repose']['filters'] = filters
end

template "#{node['repose']['config_directory']}/uri-identity.cfg.xml" do
  owner node['repose']['owner']
  group node['repose']['group']
  mode '0644'
  variables(
    mappings: node['repose']['uri_identity']['mappings'],
    group: node['repose']['uri_identity']['group'],
    quality: node['repose']['uri_identity']['quality']
  )
  notifies :restart, 'service[repose-valve]'
end
