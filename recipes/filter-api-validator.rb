#
# Cookbook Name:: repose
# Recipe:: filter-header-normalization
#
# Copyright (C) 2013 Rackspace Hosting
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
    :multi_role_match => node['repose']['api_validator']['multi_role_match'],
    :delegating_quality => node['repose']['api_validator']['delegating_quality'],
    :validators => node['repose']['api_validator']['validators']
  )
  notifies :restart, 'service[repose-valve]'
end

cookbook_file "allfeeds_observer.wadl" do
  path "#{node['repose']['config_directory']}/allfeeds_observer.wadl"
  action :create_if_missing
end

cookbook_file "allfeeds.wadl" do
  path "#{node['repose']['config_directory']}/allfeeds.wadl"
  action :create_if_missing
end
