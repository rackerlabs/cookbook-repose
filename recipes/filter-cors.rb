# frozen_string_literal: true

#
# Cookbook Name:: repose
# Recipe:: filter-cors
#
# Copyright (C) 2016 Rackspace Hosting
#

unless node['repose']['filters'].include? 'cors'
  filters = node['repose']['filters'] + ['cors']
  node.normal['repose']['filters'] = filters
end

template "#{node['repose']['config_directory']}/cors.cfg.xml" do
  owner node['repose']['owner']
  group node['repose']['group']
  mode '0644'
  variables(
    allowed_origins: node['repose']['cors']['allowed_origins'],
    allowed_methods: node['repose']['cors']['allowed_methods'],
    resources: node['repose']['cors']['resources']
  )
  notifies :restart, 'service[repose-valve]'
end
