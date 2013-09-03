require 'minitest/spec'

describe_recipe 'repose::install' do

  it 'sets up the openrepose repository' do
    file('/etc/yum.repos.d/openrepose.repo').must_exist.with(
      :owner, 'root').and(:group, 'root').and(:mode, '0644')
    assert_sh 'yum repolist | grep "Repose Public repository for RHEL"'
  end

  it 'installs Repose' do
    package('repose-valve').must_be_installed
    package('repose-filters').must_be_installed
  end

end
