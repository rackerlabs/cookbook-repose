#
# Cookbook Name:: repose
# Recipe:: default
#
# Copyright (C) 2013 Rackspace Hosting
#
# All rights reserved - Do Not Redistribute
#

include_recipe 'repose::install'

service 'repose-valve' do
  supports :restart => true, :status => true
end

include_recipe 'repose::load_peers' if node['repose']['peer_search_enabled']

template '/etc/repose/container.cfg.xml' do
  owner 'repose'
  group 'repose'
  mode '0644'
  variables(
    :port => node['repose']['port'],
    :ssl_port => node['repose']['ssl_port'],
    :connection_timeout => node['repose']['connection_timeout'],
    :read_timeout => node['repose']['read_timeout'],
    :deploy_auto_clean => node['repose']['deploy_auto_clean'],
    :filter_check_interval => node['repose']['filter_check_interval']
  )
  notifies :restart, 'service[repose-valve]'
end

template '/etc/repose/system-model.cfg.xml' do
  owner 'repose'
  group 'repose'
  mode '0644'
  variables(
    :cluster_id => node['repose']['cluster_id'],
    :peers => node['repose']['peers'],
    :filters => node['repose']['filters'],
    :endpoints => node['repose']['endpoints']
  )
  notifies :restart, 'service[repose-valve]'
end

template '/etc/repose/log4j.properties' do
  owner 'repose'
  group 'repose'
  mode '0644'
  variables(
    :loglevel => node['repose']['loglevel']
  )
  notifies :restart, 'service[repose-valve]'
end

node['repose']['filters'].each do |filter|
  include_recipe "repose::filter-#{filter}"
end
