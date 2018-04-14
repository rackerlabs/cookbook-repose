# frozen_string_literal: true

#
# Cookbook Name:: repose
# Recipe:: filter-url-extractor-to-header
#
# Copyright (C) 2015 Rackspace Hosting
#

unless node['repose']['filters'].include? 'url-extractor-to-header'
  filters = node['repose']['filters'] + ['url-extractor-to-header']
  node.normal['repose']['filters'] = filters
end

template "#{node['repose']['config_directory']}/url-extractor-to-header.cfg.xml" do
  owner node['repose']['owner']
  group node['repose']['group']
  mode '0644'
  notifies :restart, 'service[repose-valve]'
  variables(
    extractor_headers: node['repose']['url_extractor_to_header']['extractor_headers']
  )
end
