# frozen_string_literal: true

#
# Cookbook Name:: repose
# Recipe:: filter-content-type-stripper
#
# Copyright (C) 2014 Rackspace Hosting
#

unless node['repose']['filters'].include? 'content-type-stripper'
  filters = node['repose']['filters'] + ['content-type-stripper']
  node.normal['repose']['filters'] = filters
end

# No configuration template required - content-type-stripper doesn't have a config
