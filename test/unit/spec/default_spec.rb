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
end
