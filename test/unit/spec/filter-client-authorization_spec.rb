# frozen_string_literal: true
require 'chefspec'
require_relative 'spec_helper'

describe 'repose::default' do
  before { stub_resources }

  let(:chef_run) do
    ChefSpec::SoloRunner.new do |node|
      node.set['repose']['version']                                    = '7.2.0.0'
      node.set['repose']['filters']                                    = ['client-authorization']
      node.set['repose']['client_authorization']['username_admin']   = 'test_user'
      node.set['repose']['client_authorization']['password_admin']   = 'test_password'
      node.set['repose']['client_authorization']['auth_uri']         = 'test_uri'
      node.set['repose']['client_authorization']['service_endpoint'] = 'test_endpoint'
    end.converge(described_recipe)
  end

  it 'openstack-authorization has correct namespace for version 7' do
    expect(chef_run).to render_file('/etc/repose/openstack-authorization.cfg.xml').with_content(%r{<rackspace-authorization xmlns="http:\/\/openrepose.org\/repose\/openstack-identity\/auth-z\/v1.0">})
  end

  it 'openstack-authorization has correct username' do
    expect(chef_run).to render_file('/etc/repose/openstack-authorization.cfg.xml').with_content(/<authentication-server\s+username="test_user"/)
  end

  it 'openstack-authorization has correct password' do
    expect(chef_run).to render_file('/etc/repose/openstack-authorization.cfg.xml').with_content(/<authentication-server[^<]+password="test_password"/)
  end

  it 'openstack-authorization has correct uri' do
    expect(chef_run).to render_file('/etc/repose/openstack-authorization.cfg.xml').with_content(/<authentication-server[^<]+href="test_uri"/)
  end

  it 'openstack-authorization has correct service_endpoint' do
    expect(chef_run).to render_file('/etc/repose/openstack-authorization.cfg.xml').with_content(/<service-endpoint\s+href="test_endpoint"/)
  end
end

describe 'repose::default' do
  before { stub_resources }

  let(:chef_run) do
    ChefSpec::SoloRunner.new do |node|
      node.set['repose']['version']                                    = '6.2.0.0'
      node.set['repose']['filters']                                    = ['client-authorization']
      node.set['repose']['client_authorization']['username_admin']   = 'test_user'
      node.set['repose']['client_authorization']['password_admin']   = 'test_password'
      node.set['repose']['client_authorization']['auth_uri']         = 'test_uri'
      node.set['repose']['client_authorization']['service_endpoint'] = 'test_endpoint'
    end.converge(described_recipe)
  end

  it 'openstack-authorization has correct namespace for version 7' do
    expect(chef_run).to render_file('/etc/repose/openstack-authorization.cfg.xml').with_content(%r{<rackspace-authorization xmlns="http:\/\/openrepose.org\/components\/openstack-identity\/auth-z\/v1.0">})
  end

  it 'openstack-authorization has correct username' do
    expect(chef_run).to render_file('/etc/repose/openstack-authorization.cfg.xml').with_content(/<authentication-server\s+username="test_user"/)
  end

  it 'openstack-authorization has correct password' do
    expect(chef_run).to render_file('/etc/repose/openstack-authorization.cfg.xml').with_content(/<authentication-server[^<]+password="test_password"/)
  end

  it 'openstack-authorization has correct uri' do
    expect(chef_run).to render_file('/etc/repose/openstack-authorization.cfg.xml').with_content(/<authentication-server[^<]+href="test_uri"/)
  end

  it 'openstack-authorization has correct service_endpoint' do
    expect(chef_run).to render_file('/etc/repose/openstack-authorization.cfg.xml').with_content(/<service-endpoint\s+href="test_endpoint"/)
  end
end
