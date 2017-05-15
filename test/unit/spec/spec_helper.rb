# encoding: UTF-8
# frozen_string_literal: true
# -*- mode: ruby -*-
# vi: set ft=ruby :

require 'rspec/expectations'
require 'chefspec'
require 'chefspec/berkshelf'
require 'chef/application'

def stub_resources; end

at_exit { ChefSpec::Coverage.report! }
