#
# Cookbook Name:: repose
# Recipe:: install
#
# Copyright (C) 2013 Rackspace Hosting
#
# All rights reserved - Do Not Redistribute
#

yum_key 'RPM_GPG_KEY-openrepose' do
  url 'http://repo.openrepose.org/rhel/RPM_GPG_KEY-openrepose'
end

yum_repository 'openrepose' do
  description 'Repose Public repository for RHEL'
  url 'http://repo.openrepose.org/rhel'
  # the openrepose repo provides a GPG key but doesn't sign packages, what?
  # key 'RPM_GPG_KEY-openrepose'
end

package 'repose-valve'
package 'repose-filters'
