# frozen_string_literal: true

#
# Cookbook Name:: repose
# Recipe:: filter-ip-user
#
# Copyright (C) 2016 Rackspace Hosting
#

unless node['repose']['filters'].include? 'ip-user'
  filters = node['repose']['filters'] + ['ip-user']
  node.normal['repose']['filters'] = filters
end

template "#{node['repose']['config_directory']}/ip-user.cfg.xml" do
  owner node['repose']['owner']
  group node['repose']['group']
  mode '0644'
  variables(
    user_header_name: node['repose']['ip_user']['user_header_name'],
    user_header_quality: node['repose']['ip_user']['user_header_quality'],
    group_header_name: node['repose']['ip_user']['group_header_name'],
    group_header_quality: node['repose']['ip_user']['group_header_quality'],
    groups: node['repose']['ip_user']['groups']
  )
  notifies :restart, 'service[repose-valve]'
end
