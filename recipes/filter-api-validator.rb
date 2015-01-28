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

node['repose']['api_validator']['validators'].each do |f|
  if f.has_key?("wadl") 
    wfile = f['wadl']
    cookbook_file wfile do
      path "#{node['repose']['config_directory']}/#{wfile}"
      action :create_if_missing
    end
  end
end
