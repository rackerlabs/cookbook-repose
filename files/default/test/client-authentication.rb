require 'minitest/spec'

describe_recipe 'repose::filter-client-authentication' do

  it 'sets up client-authorization.cfg.xml' do
    file('/etc/repose/client-authorization.cfg.xml').must_exist.with(
      :owner, node['repose']['owner']).and(
      :group, node['repose']['group']).and(
      :mode, '0644')
  end

end


