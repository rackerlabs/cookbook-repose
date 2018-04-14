# frozen_string_literal: true

#
# Cookbook Name:: repose
# Recipe:: filter-ip-identity
#
# Copyright (C) 2013 Rackspace Hosting
#

unless node['repose']['filters'].include? 'ip-identity'
  filters = node['repose']['filters'] + ['ip-identity']
  node.normal['repose']['filters'] = filters
end

template "#{node['repose']['config_directory']}/ip-identity.cfg.xml" do
  owner node['repose']['owner']
  group node['repose']['group']
  mode '0644'
  variables(
    quality: node['repose']['ip_identity']['quality'],
    white_list_quality: node['repose']['ip_identity']['white_list_quality'],
    white_list_ip_addresses: node['repose']['ip_identity']['white_list_ip_addresses']
  )
  notifies :restart, 'service[repose-valve]'
end
