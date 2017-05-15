# frozen_string_literal: true
require 'chefspec'
require_relative 'spec_helper'

describe 'repose::install_rhel' do
  before { stub_resources }
  let(:chef_run) { ChefSpec::SoloRunner.new(platform: 'redhat', version: '7.0').converge('repose::default', 'repose::install', described_recipe) }
  let(:template) { chef_run.template('/etc/sysconfig/repose') }

  it 'includes the recipe yum-epel' do
    expect(chef_run).to include_recipe('yum-epel')
  end

  it 'sends a restart notification to the service' do
    expect(template).to notify('service[repose-valve]').to(:restart)
  end

  it 'install the yum repository' do
    expect(chef_run).to create_yum_repository('openrepose').with(
      baseurl: 'http://repo.openrepose.org/rhel',
      gpgkey: 'http://repo.openrepose.org/rhel/RPM_GPG_KEY-openrepose',
      gpgcheck: false,
      enabled: true
    )
  end

  it 'creates the file /etc/init.d/repose-valve' do
    expect(chef_run).to create_file('/etc/init.d/repose-valve')
  end

  it 'creates a template /etc/sysconfig/repose' do
    expect(chef_run).to create_template('/etc/sysconfig/repose')
  end

  packages = %w(repose-valve repose-filter-bundle repose-extensions-filter-bundle)
  packages.each do |p|
    it 'installs package #{p}' do
      expect(chef_run).to install_package(p)
    end
  end
end
