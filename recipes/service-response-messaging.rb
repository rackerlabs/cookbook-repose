# frozen_string_literal: true

#
# Cookbook Name:: repose
# Recipe:: service-response-messaging
#
# Copyright (C) 2016 Rackspace Hosting
#

template "#{node['repose']['config_directory']}/response-messaging.cfg.xml" do
  owner node['repose']['owner']
  group node['repose']['group']
  mode '0644'
  variables(
    status_codes: node['repose']['response_messaging']['status_codes']
  )
end
