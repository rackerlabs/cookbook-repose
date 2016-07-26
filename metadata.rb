name 'repose'
maintainer 'Rackspace Hosting'
maintainer_email 'cit-ops@rackspace.com'
license 'All rights reserved'
description 'Installs/Configures repose'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version '3.3.6'
issues_url 'https://github.com/rackerlabs/cookbook-repose/issues' if respond_to?(:issues_url)
source_url 'https://github.com/rackerlabs/cookbook-repose' if respond_to?(:source_url)

depends 'apt'
depends 'yum', '~> 3.0'
depends 'yum-epel'
