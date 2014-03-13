#
# Cookbook Name:: repose
# Recipe:: install_debian
#
# Copyright (C) 2013 Rackspace Hosting
#
# All rights reserved - Do Not Redistribute
#

apt_repository 'openrepose' do
  uri node['repose']['repo']['baseurl']
  distribution 'stable'
  components ['main']
  key node['repose']['repo']['gpgkey']
end

%w{ repose-valve
    repose-filter-bundle
}.each do |p|
  package p do
    options node['repose']['install_opts']
    version node['repose']['version']
  end
end
