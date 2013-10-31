#
# Cookbook Name:: repose
# Recipe:: filter-client-auth
#
# Copyright (C) 2013 Rackspace Hosting
#
# All rights reserved - Do Not Redistribute
#

include_recipe 'repose::install'

unless node['repose']['filters'].include? 'client-auth'
  filters = node['repose']['filters'] + ['client-auth']
  node.normal['repose']['filters'] = filters
end

if node[:repose][:auth_provider] == 'RACKSPACE'
  template '/etc/repose/client-auth-n.cfg.xml' do
    source "client-auth-n.cfg.xml.rackspace.erb"
    owner node['repose']['owner']
    group node['repose']['group']
    mode '0644'
    variables(
      :username => node['repose']['client_auth']['username_admin'],
      :password => node['repose']['client_auth']['password_admin'],
      :auth_uri => node['repose']['client_auth']['auth_uri']
    )
    notifies :restart, 'service[repose-valve]'
  end
else
  template "/etc/repose/client-auth-n.cfg.xml" do
    source "client-auth-n.cfg.xml.openstack.erb"
    owner node['repose']['owner']
    group node['repose']['group']
    mode '0644'
    variables(
      :username => node['repose']['client_auth']['username_admin'],
      :password => node['repose']['client_auth']['password_admin'],
      :auth_uri => node['repose']['client_auth']['auth_uri'],
      :tenant_id => node['repose']['client_auth']['tenant_id']
    )
  end
end
