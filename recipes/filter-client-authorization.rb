# frozen_string_literal: true

#
# Cookbook Name:: repose
# Recipe:: filter-client-authorization
#
# Copyright (C) 2015 Rackspace Hosting
#

unless node['repose']['filters'].include? 'client-authorization'
  filters = node['repose']['filters'] + ['client-authorization']
  node.normal['repose']['filters'] = filters
end

template "#{node['repose']['config_directory']}/openstack-authorization.cfg.xml" do
  owner node['repose']['owner']
  group node['repose']['group']
  mode '0640'
  variables(
    username: node['repose']['client_authorization']['username_admin'],
    password: node['repose']['client_authorization']['password_admin'],
    auth_uri: node['repose']['client_authorization']['auth_uri'],
    tenant_id_admin: node['repose']['client_authorization']['tenant_id_admin'],
    endpoint_list_ttl: node['repose']['client_authorization']['endpoint_list_ttl'],
    connection_pool_id: node['repose']['client_authorization']['connection_pool_id'],
    service_endpoint: node['repose']['client_authorization']['service_endpoint'],
    service_region: node['repose']['client_authorization']['service_region'],
    service_name: node['repose']['client_authorization']['service_name'],
    service_type: node['repose']['client_authorization']['service_type'],
    ignore_tenant_roles: node['repose']['client_authorization']['ignore_tenant_roles'],
    roles: node['repose']['client_authorization']['roles'],
    delegating_quality: node['repose']['client_authorization']['delegating_quality'],
    version: node['repose']['version']
  )
  notifies :restart, 'service[repose-valve]'
end
