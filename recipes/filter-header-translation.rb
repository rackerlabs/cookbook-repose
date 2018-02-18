# frozen_string_literal: true

#
# Cookbook Name:: repose
# Recipe:: filter-header-translation
#
# Copyright (C) 2013 Rackspace Hosting
#

unless node['repose']['filters'].include? 'header-translation'
  filters = node['repose']['filters'] + ['header-translation']
  node.normal['repose']['filters'] = filters
end

template "#{node['repose']['config_directory']}/header-translation.cfg.xml" do
  owner node['repose']['owner']
  group node['repose']['group']
  mode '0644'
  variables(
    headers: node['repose']['header_translation']['headers']
  )
  notifies :restart, 'service[repose-valve]'
end
