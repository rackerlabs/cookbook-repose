# frozen_string_literal: true

#
# Cookbook Name:: repose
# Recipe:: filter-translation
#
# Copyright (C) 2014 Rackspace Hosting
#

unless node['repose']['filters'].include? 'translation'
  filters = node['repose']['filters'] + ['translation']
  node.normal['repose']['filters'] = filters
end

template "#{node['repose']['config_directory']}/translation.cfg.xml" do
  owner node['repose']['owner']
  group node['repose']['group']
  mode '0644'
  variables(
    allow_doctype_decl: node['repose']['translation']['allow_doctype_decl'],
    request_translations: node['repose']['translation']['request_translations'],
    response_translations: node['repose']['translation']['response_translations'],
    version: node['repose']['version']
  )
  notifies :restart, 'service[repose-valve]'
end
