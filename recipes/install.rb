#
# Cookbook Name:: repose
# Recipe:: install
#
# Copyright (C) 2013 Rackspace Hosting
#
# All rights reserved - Do Not Redistribute
#

include_recipe value_for_platform_family(
  'rhel'   => 'repose::install_rhel',
  'debian' => 'repose::install_debian'
)
