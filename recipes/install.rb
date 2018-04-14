# frozen_string_literal: true

#
# Cookbook Name:: repose
# Recipe:: install
#
# Copyright (C) 2013 Rackspace Hosting
#

case node['platform_family']
when 'rhel'
  include_recipe 'repose::install_rhel'
when 'debian'
  include_recipe 'repose::install_debian'
end
