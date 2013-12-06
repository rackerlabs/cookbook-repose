require 'minitest/spec'

describe_recipe 'repose::filter-client-auth' do

  it 'sets up client-auth-n.cfg.xml' do
    file('/etc/repose/client-auth-n.cfg.xml').must_exist.with(
      :owner, node['repose']['owner']).and(
      :group, node['repose']['group']).and(
      :mode, '0644')
  end

end
