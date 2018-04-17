# frozen_string_literal: true

#
# Cookbook Name:: repose
# Recipe:: default
#
# Copyright (C) 2013 Rackspace Hosting
#

include_recipe 'repose::install'

service 'repose-valve' do
  supports restart: true, status: true
  action %i[enable start]
end

include_recipe 'repose::load_peers' if node['repose']['peer_search_enabled']

unless node['repose']['cluster_id'].nil?
  log "Please note that node['repose']['cluster_id'] is deprecated. We've set node['repose']['cluster_ids'] to [#{node['repose']['cluster_id']}] in an effort to maintain compatability with earlier versions. This functionality will be removed in a future version."
  node.normal['repose']['cluster_ids'] = [node['repose']['cluster_id']]
end

directory node['repose']['config_directory'] do
  owner node['repose']['owner']
  group node['repose']['group']
  mode '0755'
  recursive true
end

# http-connection-pool, response-messaging, and open-tracing do not need to be included in the system-model.cfg.xml file
services = node['repose']['services'].reject { |x| x == 'http-connection-pool' || x == 'response-messaging' || x == 'open-tracing' }
service_cluster_map = {
  'dist-datastore' => node['repose']['dist_datastore']['cluster_id'],
  'http-connection-pool' => node['repose']['http_connection_pool']['cluster_id'],
  'response-messaging' => node['repose']['response_messaging']['cluster_id'],
  'open-tracing' => node['repose']['open_tracing']['cluster_id']
}

filters = node['repose']['filters']
filter_cluster_map = {
  'add-header'              => node['repose']['add_header']['cluster_id'],
  'api-validator'           => node['repose']['api_validator']['cluster_id'],
  'client-auth'             => node['repose']['client_auth']['cluster_id'],
  'client-authorization'    => node['repose']['client_authorization']['cluster_id'],
  'content-type-stripper'   => node['repose']['content_type_stripper']['cluster_id'],
  'cors'                    => node['repose']['cors']['cluster_id'],
  'derp'                    => node['repose']['derp']['cluster_id'],
  'header-identity'         => node['repose']['header_identity']['cluster_id'],
  'header-normalization'    => node['repose']['header_normalization']['cluster_id'],
  'header-translation'      => node['repose']['header_translation']['cluster_id'],
  'ip-identity'             => node['repose']['ip_identity']['cluster_id'],
  'ip-user'                 => node['repose']['ip_user']['cluster_id'],
  'keystone-v2'             => node['repose']['keystone_v2']['cluster_id'],
  'merge-header'            => node['repose']['merge_header']['cluster_id'],
  'rackspace-auth-user'     => node['repose']['rackspace_auth_user']['cluster_id'],
  'rate-limiting'           => node['repose']['rate_limiting']['cluster_id'],
  'slf4j-http-logging'      => node['repose']['slf4j_http_logging']['cluster_id'],
  'translation'             => node['repose']['translation']['cluster_id'],
  'uri-identity'            => node['repose']['uri_identity']['cluster_id'],
  'uri-stripper'            => node['repose']['uri_stripper']['cluster_id'],
  'url-extractor-to-header' => node['repose']['url_extractor_to_header']['cluster_id']
}

template "#{node['repose']['config_directory']}/system-model.cfg.xml" do
  owner node['repose']['owner']
  group node['repose']['group']
  mode '0644'
  variables(
    cluster_ids: node['repose']['cluster_ids'],
    rewrite_host_header: node['repose']['rewrite_host_header'],
    nodes: node['repose']['peers'],
    services: services,
    service_cluster_map: service_cluster_map,
    filters: filters,
    filter_cluster_map: filter_cluster_map,
    endpoints: node['repose']['endpoints'],
    version: node['repose']['version']
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

template "#{node['repose']['config_directory']}/log4j2.xml" do
  owner node['repose']['owner']
  group node['repose']['group']
  mode '0644'
  variables(
    loglevel: node['repose']['loglevel'],
    openrepose_loglevel: node['repose']['openrepose_loglevel'],
    intrafilter_loglevel: node['repose']['intrafilter_loglevel'],
    loggers: node['repose']['loggers'],
    appenders: node['repose']['appenders'],
    tracing_log_level: node['repose']['open_tracing']['constant']['toggle'] == 'off' && node['repose']['open_tracing']['sampling_type'] == 'constant' ? 'off' : 'warn'
  )
  notifies :restart, 'service[repose-valve]'
end

template "#{node['repose']['config_directory']}/container.cfg.xml" do
  owner node['repose']['owner']
  group node['repose']['group']
  mode '0644'
  variables(
    content_body_read_limit: node['repose']['content_body_read_limit'],
    connection_timeout: node['repose']['connection_timeout'],
    read_timeout: node['repose']['read_timeout'],
    deploy_auto_clean: node['repose']['deploy_auto_clean'],
    filter_check_interval: node['repose']['filter_check_interval'],
    client_request_logging: node['repose']['client_request_logging'],
    version: node['repose']['version']
  )
  notifies :restart, 'service[repose-valve]'
end

node['repose']['filters'].each do |filter|
  include_recipe "repose::filter-#{filter}"
end

node['repose']['services'].each do |service|
  include_recipe "repose::service-#{service}"
end
