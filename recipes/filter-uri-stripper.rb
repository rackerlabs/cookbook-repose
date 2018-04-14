# frozen_string_literal: true

#
# Cookbook Name:: repose
# Recipe:: filter-uri-stripper
#
# Copyright (C) 2014 Rackspace Hosting
#

unless node['repose']['filters'].include? 'uri-stripper'
  filters = node['repose']['filters'] + ['uri-stripper']
  node.normal['repose']['filters'] = filters
end

template "#{node['repose']['config_directory']}/uri-stripper.cfg.xml" do
  owner node['repose']['owner']
  group node['repose']['group']
  mode '0644'
  variables(
    rewrite_location: node['repose']['uri_stripper']['rewrite_location'],
    token_index: node['repose']['uri_stripper']['token_index']
  )
  notifies :restart, 'service[repose-valve]'
end
