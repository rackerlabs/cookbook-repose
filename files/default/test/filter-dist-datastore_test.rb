require 'minitest/spec'

describe_recipe 'repose::filter-dist-datastore' do

  it 'sets up dist-datastore.cfg.xml' do
    file('/etc/repose/dist-datastore.cfg.xml').must_exist.with(
      :owner, node['repose']['owner']).and(
      :group, node['repose']['group']).and(
      :mode, '0644')
  end

end
