# frozen_string_literal: true

#
# Cookbook Name:: repose
# Recipe:: service-dist-datastore
#
# Copyright (C) 2013 Rackspace Hosting
#

unless node['repose']['services'].include? 'dist-datastore'
  services = node['repose']['services'] + ['dist-datastore']
  node.normal['repose']['services'] = services
end

template "#{node['repose']['config_directory']}/dist-datastore.cfg.xml" do
  owner node['repose']['owner']
  group node['repose']['group']
  mode '0644'
  variables(
    allow_all: node['repose']['dist_datastore']['allow_all'],
    allowed_hosts: node['repose']['dist_datastore']['allowed_hosts'],
    cluster_ids: node['repose']['cluster_ids'],
    port: node['repose']['dist_datastore']['port']
  )
  notifies :restart, 'service[repose-valve]'
end
