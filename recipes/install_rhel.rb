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
  baseurl node['repose']['baseurl']
  gpgkey node['repose']['gpgkey']
  gpgcheck node['repose']['gpgcheck']
end

package 'repose-valve'
package 'repose-filters'

template '/etc/sysconfig/repose' do
  owner 'root'
  group 'root'
  mode '0644'
  variables(
    node['repose']
  )
  notifies :restart, 'service[repose-valve]'
end
