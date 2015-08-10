require 'minitest/spec'

describe_recipe 'repose::filter-slf4j-http-logging' do
  it 'sets up slf4j-http-logging.cfg.xml' do
    file('/etc/repose/slf4j-http-logging.cfg.xml').must_exist.with(
      :owner, node['repose']['owner']).and(
        :group, node['repose']['group']).and(
          :mode, '0644')
  end
end
