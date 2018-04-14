# frozen_string_literal: true

#
# Cookbook Name:: repose
# Recipe:: filter-keystone-v2
#
# Copyright (C) 2013 Rackspace Hosting
#

unless node['repose']['filters'].include? 'keystone-v2'
  filters = node['repose']['filters'] + ['keystone-v2']
  node.normal['repose']['filters'] = filters
end

template "#{node['repose']['config_directory']}/keystone-v2.cfg.xml" do
  owner node['repose']['owner']
  group node['repose']['group']
  mode '0640'
  variables(
    username: node['repose']['keystone_v2']['username_admin'],
    password: node['repose']['keystone_v2']['password_admin'],
    uri: node['repose']['keystone_v2']['uri'],
    pool: node['repose']['keystone_v2']['pool'],
    groups_in_header: node['repose']['keystone_v2']['groups_in_header'],
    roles_in_header: node['repose']['keystone_v2']['roles_in_header'],
    catalog_in_header: node['repose']['keystone_v2']['catalog_in_header'],
    delegating_quality: node['repose']['keystone_v2']['delegating_quality'],
    white_list: node['repose']['keystone_v2']['white_list'],
    cache: node['repose']['keystone_v2']['cache'],
    tenant_handling: node['repose']['keystone_v2']['tenant_handling'],
    require_service_endpoint: node['repose']['keystone_v2']['require_service_endpoint'],
    pre_authorized_roles: node['repose']['keystone_v2']['pre_authorized_roles']
  )
  notifies :restart, 'service[repose-valve]'
end
