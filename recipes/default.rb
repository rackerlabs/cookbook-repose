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

template "#{node['repose']['config_directory']}/system-model.cfg.xml" do
  owner node['repose']['owner']
  group node['repose']['group']
  mode '0644'
  variables(
    cluster_ids: node['repose']['cluster_ids'],
    nodes: node['repose']['peers'],
    services: node['repose']['services'],
    filters: node['repose']['filters'],
    endpoints: node['repose']['endpoints']
  )
  notifies :restart, 'service[repose-valve]'
end

template "#{node['repose']['config_directory']}/log4j.properties" do
  owner node['repose']['owner']
  group node['repose']['group']
  mode '0644'
  variables(
    loglevel: node['repose']['loglevel']
  )
  notifies :restart, 'service[repose-valve]'
end

template "#{node['repose']['config_directory']}/container.cfg.xml" do
  owner node['repose']['owner']
  group node['repose']['group']
  mode '0644'
  variables(
    connection_timeout: node['repose']['connection_timeout'],
    read_timeout: node['repose']['read_timeout'],
    deploy_auto_clean: node['repose']['deploy_auto_clean'],
    filter_check_interval: node['repose']['filter_check_interval']
  )
  notifies :restart, 'service[repose-valve]'
end

node['repose']['filters'].each do |filter|
  include_recipe "repose::filter-#{filter}"
end

node['repose']['services'].each do |service|
  include_recipe "repose::service-#{service}"
end
