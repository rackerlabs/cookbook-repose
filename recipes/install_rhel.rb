#
# Cookbook Name:: repose
# Recipe:: install_rhel
#
# Copyright (C) 2013 Rackspace Hosting
#
# All rights reserved - Do Not Redistribute
#

case node['platform_version'].to_i
when 5
  yum_repository 'epel' do
    baseurl 'http://dl.fedoraproject.org/pub/epel/5/$basearch/'
    description 'Extra Packages for Enterprise Linux 5 - $basearch'
    gpgkey 'http://dl.fedoraproject.org/pub/epel/RPM-GPG-KEY-EPEL'
  end
when 6
  yum_repository 'epel' do
    baseurl 'http://dl.fedoraproject.org/pub/epel/6/$basearch/'
    description 'Extra Packages for Enterprise Linux 6 - $basearch'
    gpgkey 'http://dl.fedoraproject.org/pub/epel/RPM-GPG-KEY-EPEL-6'
  end
end

yum_repository 'openrepose' do
  description 'Repose Public repository for RHEL'
  baseurl 'http://repo.openrepose.org/rhel'
  # the openrepose repo doesn't sign packages
  # gpgkey 'http://repo.openrepose.org/rhel/RPM_GPG_KEY-openrepose'
  gpgcheck false
end

package 'repose-valve'
package 'repose-filters'
