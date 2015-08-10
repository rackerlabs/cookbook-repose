require 'minitest/spec'

describe_recipe 'repose::filter-rackspace-auth-user' do
  it 'sets up rackspace-auth-user.cfg.xml' do
    file('/etc/repose/rackspace-auth-user.cfg.xml').must_exist.with(
      :owner, node['repose']['owner']).and(
        :group, node['repose']['group']).and(
          :mode, '0644')
  end
end
