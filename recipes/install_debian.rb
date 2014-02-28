#
# Cookbook Name:: repose
# Recipe:: install_debian
#
# Copyright (C) 2013 Rackspace Hosting
#
# All rights reserved - Do Not Redistribute
#

apt_repository 'openrepose' do
  uri node['repose']['uri']
  distribution 'stable'
  components ['main']
  key node['repose']['key']
end

package 'repose-valve' do
  options '--force-yes' # the openrepose repo doesn't sign packages
end

package 'repose-filter-bundle' do
  options '--force-yes' # the openrepose repo doesn't sign packages
end
