# frozen_string_literal: true

name 'repose'
maintainer 'Rackspace Hosting'
maintainer_email 'cookbook-repose@rackspace.com'
license 'All rights reserved'
description 'Installs/Configures repose'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version '3.6.0'
chef_version '>= 12' if respond_to?(:chef_version)
issues_url 'https://github.com/rackerlabs/cookbook-repose/issues' if respond_to?(:issues_url)
source_url 'https://github.com/rackerlabs/cookbook-repose' if respond_to?(:source_url)

depends 'apt'
depends 'yum'
depends 'yum-epel'

supports 'centos'
supports 'ubuntu'
