require 'minitest/spec'

describe_recipe 'repose::filter-api-validator' do

  it 'sets up validator.cfg.xml' do
    file('/etc/repose/validator.cfg.xml').must_exist.with(
      :owner, node['repose']['owner']).and(
      :group, node['repose']['group']).and(
      :mode, '0644')
  end

end
