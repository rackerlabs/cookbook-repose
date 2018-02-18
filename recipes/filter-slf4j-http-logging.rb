# frozen_string_literal: true

#
# Cookbook Name:: repose
# Recipe:: filter-slf4j-http-logging
#
# Copyright (C) 2013 Rackspace Hosting
#

unless node['repose']['filters'].include? 'slf4j-http-logging'
  filters = node['repose']['filters'] + ['slf4j-http-logging']
  node.normal['repose']['filters'] = filters
end

template "#{node['repose']['config_directory']}/slf4j-http-logging.cfg.xml" do
  owner node['repose']['owner']
  group node['repose']['group']
  mode '0644'
  variables(
    id: node['repose']['slf4j_http_logging']['id'],
    format: node['repose']['slf4j_http_logging']['format']
  )
  notifies :restart, 'service[repose-valve]'
end
