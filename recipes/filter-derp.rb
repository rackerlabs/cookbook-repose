#
# Cookbook Name:: repose
# Recipe:: filter-derp
#
# Copyright (C) 2013 Rackspace Hosting
#

include_recipe 'repose::install'

unless node['repose']['filters'].include? 'derp'
  filters = node['repose']['filters'] + ['derp']
  node.normal['repose']['filters'] = filters
end

# No configuration template required - derp doesn't have a config
