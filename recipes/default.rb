#
# Cookbook Name:: repose
# Recipe:: default
#
# Copyright (C) 2013 Rackspace Hosting
#

include_recipe 'repose::install'

service 'repose-valve' do
  supports :restart => true, :status => true
  action [:enable, :start]
end

include_recipe 'repose::load_peers' if node['repose']['peer_search_enabled']

directory "#{node['repose']['config_directory']}" do
  owner node['repose']['owner']
  group node['repose']['group']
  mode '0755'
end

%w{ container.cfg.xml
    system-model.cfg.xml
    log4j.properties
}.each do |filename|
  template "#{node['repose']['config_directory']}/#{filename}" do
    owner node['repose']['owner']
    group node['repose']['group']
    mode '0644'
    variables(
      node['repose']
    )
    notifies :restart, 'service[repose-valve]'
  end
end

node['repose']['filters'].each do |filter|
  include_recipe "repose::filter-#{filter}"
end

node['repose']['services'].each do |service|
  include_recipe "repose::service-#{service}"
end
