#
# Cookbook Name:: repose
# Recipe:: filter-client-auth
#
# Copyright (C) 2013 Rackspace Hosting
#

include_recipe 'repose::install'

unless node['repose']['filters'].include? 'client-auth'
  filters = node['repose']['filters'] + ['client-auth']
  node.normal['repose']['filters'] = filters
end

template "#{node['repose']['config_directory']}/client-auth-n.cfg.xml" do
  owner node['repose']['owner']
  group node['repose']['group']
  mode '0644'
  variables(
    :auth_provider => node['repose']['client_auth']['auth_provider'],
    :username => node['repose']['client_auth']['username_admin'],
    :password => node['repose']['client_auth']['password_admin'],
    :auth_uri => node['repose']['client_auth']['auth_uri'],
    :mapping_regex => node['repose']['client_auth']['mapping_regex'],
    :mapping_type => node['repose']['client_auth']['mapping_type'],
    :tenant_id => node['repose']['client_auth']['tenant_id'],
    :delegable => node['repose']['client_auth']['delegable'],
    :tenanted => node['repose']['client_auth']['tenanted'],
    :request_groups => node['repose']['client_auth']['request_groups'],
    :token_cache_timeout => node['repose']['client_auth']['token_cache_timeout'],
    :group_cache_timeout => node['repose']['client_auth']['group_cache_timeout'],
    :endpoints_in_header => node['repose']['client_auth']['endpoints_in_header']
  )
  notifies :restart, 'service[repose-valve]'
end
