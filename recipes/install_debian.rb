# frozen_string_literal: true

#
# Cookbook Name:: repose
# Recipe:: install_debian
#
# Copyright (C) 2013 Rackspace Hosting
#

include_recipe 'apt::default'

apt_repository 'openrepose' do
  uri node['repose']['repo']['baseurl']
  distribution 'stable'
  components ['main']
  key node['repose']['repo']['gpgkey']
  only_if { node['repose']['repo']['managed'] }
end

%w[repose-valve
   repose-filter-bundle
   repose-extensions-filter-bundle].each do |p|
  package p do
    options node['repose']['install_opts']
    version node['repose']['version']
  end
end
