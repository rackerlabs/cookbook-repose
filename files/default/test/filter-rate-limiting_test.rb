require 'minitest/spec'

describe_recipe 'repose::filter-rate-limiting' do
  it 'sets up rate-limiting.cfg.xml' do
    file('/etc/repose/rate-limiting.cfg.xml').must_exist.with(
      :owner, node['repose']['owner']).and(
        :group, node['repose']['group']).and(
          :mode, '0644')
  end
end
