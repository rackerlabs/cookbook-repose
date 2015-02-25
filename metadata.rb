name             'repose'
maintainer       'Rackspace Hosting'
maintainer_email 'cit-ops@rackspace.com'
license          'All rights reserved'
description      'Installs/Configures repose'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '2.9.1'

depends          'apt'
depends          'yum', '~> 3.0'
depends          'yum-epel'
