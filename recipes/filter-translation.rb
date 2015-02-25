#
# Cookbook Name:: repose
# Recipe:: filter-translation
#
# Copyright (C) 2014 Rackspace Hosting
#

include_recipe 'repose::install'

unless node['repose']['filters'].include? 'translation'
  filters = node['repose']['filters'] + ['translation']
  node.normal['repose']['filters'] = filters
end

template "#{node['repose']['config_directory']}/translation.cfg.xml" do
  owner node['repose']['owner']
  group node['repose']['group']
  mode '0644'
  variables(
    request_translations: node['repose']['translation']['request_translations'],
    response_translations: node['repose']['translation']['response_translations']
  )
  notifies :restart, 'service[repose-valve]'
end
