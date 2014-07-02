#
# Cookbook Name:: repose
# Recipe:: install_rhel
#
# Copyright (C) 2013 Rackspace Hosting
#
# All rights reserved - Do Not Redistribute
#

include_recipe 'yum-epel'

yum_repository 'openrepose' do
  description 'Repose Public repository for RHEL'
  baseurl node['repose']['repo']['baseurl']
  gpgkey node['repose']['repo']['gpgkey']
  gpgcheck node['repose']['repo']['gpgcheck']
  enabled node['repose']['repo']['enabled']
  only_if { node['repose']['repo']['managed'] }
end

%w{ repose-valve
    repose-filters
}.each do |p|
  package p do
    options node['repose']['install_opts']
    version node['repose']['version']
  end
end

template '/etc/sysconfig/repose' do
  owner 'root'
  group 'root'
  mode '0644'
  variables(
    node['repose']
  )
  notifies :restart, 'service[repose-valve]'
end
