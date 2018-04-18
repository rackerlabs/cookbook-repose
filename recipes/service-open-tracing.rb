# frozen_string_literal: true

#
# Cookbook Name:: repose
# Recipe:: service-open-tracing
#
# Copyright (C) 2018 Rackspace Hosting
#

unless node['repose']['services'].include? 'open-tracing'
  services = node['repose']['services'] + ['open-tracing']
  node.normal['repose']['services'] = services
end

template "#{node['repose']['config_directory']}/open-tracing.cfg.xml" do
  owner node['repose']['owner']
  group node['repose']['group']
  mode '0644'
  variables(
    service_name: node['repose']['open_tracing']['service_name'],
    connection_type: node['repose']['open_tracing']['connection_type'],
    endpoint: node['repose']['open_tracing']['http']['endpoint'],
    host: node['repose']['open_tracing']['udp']['host'],
    port: node['repose']['open_tracing']['udp']['port'],
    sampling_type: node['repose']['open_tracing']['sampling_type'],
    toggle: node['repose']['open_tracing']['constant']['toggle'],
    probability: node['repose']['open_tracing']['probabilistic']['probability'],
    max_traces_per_second: node['repose']['open_tracing']['rate_limiting']['max_traces_per_second'],
    username: node['repose']['open_tracing']['http']['username'],
    password: node['repose']['open_tracing']['http']['password'],
    token: node['repose']['open_tracing']['http']['token']
  )
  notifies :restart, 'service[repose-valve]'
end
