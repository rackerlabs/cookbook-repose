require 'minitest/spec'

describe_recipe 'repose::default' do

  it 'starts the repose-valve service' do
    service('repose-valve').must_be_enabled
    service('repose-valve').must_be_running
  end

  it 'sets up container.cfg.xml' do
    file('/etc/repose/container.cfg.xml').must_exist.with(
      :owner, node['repose']['owner']).and(
      :group, node['repose']['group']).and(
      :mode, '0644')
  end

  it 'sets up system-model.cfg.xml' do
    file('/etc/repose/system-model.cfg.xml').must_exist.with(
      :owner, node['repose']['owner']).and(
      :group, node['repose']['group']).and(
      :mode, '0644')
  end

  it 'sets up log4j.properties' do
    file('/etc/repose/log4j.properties').must_exist.with(
      :owner, node['repose']['owner']).and(
      :group, node['repose']['group']).and(
      :mode, '0644')
  end

end

