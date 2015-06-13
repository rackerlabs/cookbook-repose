#
# Cookbook Name:: repose
# Recipe:: filter-api-validator
#
# Copyright (C) 2015 Rackspace Hosting
#

include_recipe 'repose::install'

unless node['repose']['filters'].include? 'api-validator'
  filters = node['repose']['filters'] + ['api-validator']
  node.normal['repose']['filters'] = filters
end

template "#{node['repose']['config_directory']}/validator.cfg.xml" do
  owner node['repose']['owner']
  group node['repose']['group']
  mode '0644'
  variables(
    wadl: node['repose']['api_validator']['wadl'],
    dot_output: node['repose']['api_validator']['dot_output'],
    enable_rax_roles: node['repose']['api_validator']['enable_rax_roles'],
    version: node['repose']['version'],
    enable_api_coverage: node['repose']['api_validator']['enable_api_coverage']
  )
  notifies :restart, 'service[repose-valve]'
end
