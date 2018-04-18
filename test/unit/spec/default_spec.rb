# frozen_string_literal: true

require 'chefspec'
require_relative 'spec_helper'

describe 'repose::default' do
  before { stub_resources }

  let(:chef_run) { ChefSpec::SoloRunner.new.converge(described_recipe) }

  it 'starts repose-valve service' do
    expect(chef_run).to start_service('repose-valve')
  end
  it 'creates a directory /etc/repose' do
    expect(chef_run).to create_directory('/etc/repose')
  end
  it 'creates a template /etc/repose/system-model.cfg.xml' do
    expect(chef_run).to create_template('/etc/repose/system-model.cfg.xml')
  end
  it 'creates a template /etc/repose/log4j.properties' do
    expect(chef_run).to create_template('/etc/repose/log4j.properties')
  end
  it 'creates a template /etc/repose/container.cfg.xml' do
    expect(chef_run).to create_template('/etc/repose/container.cfg.xml')
  end
  it 'creates a template /etc/repose/log4j2.xml' do
    expect(chef_run).to create_template('/etc/repose/log4j2.xml')
  end

  it 'tracing log level is set to off by default' do
    expect(chef_run).to render_file('/etc/repose/log4j2.xml').with_content(%r{<Logger name="com.uber.jaeger" level="off"/>})
  end
end

describe 'repose::default' do
  before { stub_resources }

  let(:chef_run) do
    ChefSpec::SoloRunner.new do |node|
      node.set['repose']['version']                         = '8.8.3.0'
      node.set['repose']['services']                        = ['open-tracing']
      node.set['repose']['open_tracing']['connection_type'] = 'udp'
      node.set['repose']['open_tracing']['sampling_type']   = 'probabilistic'
      node.set['repose']['open_tracing']['probabilistic']['probability'] = '0.9'
    end.converge(described_recipe)
  end

  it 'tracing log level is set to warn if tracing is used' do
    expect(chef_run).to render_file('/etc/repose/log4j2.xml').with_content(%r{<Logger name="com.uber.jaeger" level="warn"/>})
  end
end
