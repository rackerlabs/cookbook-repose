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

pkgs = node['repose']['packages'].map{ |p| [p, node['repose']['version']].join('=')}

bash 'install repose packages' do
  code "apt #{node['repose']['install_opts']} install #{pkgs.join(' ')}"
end
