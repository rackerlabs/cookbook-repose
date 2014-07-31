#
# Cookbook Name:: repose
# Recipe:: install
#
# Copyright (C) 2013 Rackspace Hosting
#

include_recipe value_for_platform_family(
  'rhel'   => 'repose::install_rhel',
  'debian' => 'repose::install_debian'
)
