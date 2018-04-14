# frozen_string_literal: true

#
# Cookbook Name:: repose
# Recipe:: filter-api-validator
#
# Copyright (C) 2015 Rackspace Hosting
#

unless node['repose']['filters'].include? 'api-validator'
  filters = node['repose']['filters'] + ['api-validator']
  node.normal['repose']['filters'] = filters
end

template "#{node['repose']['config_directory']}/validator.cfg.xml" do
  owner node['repose']['owner']
  group node['repose']['group']
  mode '0644'
  variables(
    version: node['repose']['version'],
    multi_role_match: node['repose']['api_validator']['multi_role_match'],
    wadl: node['repose']['api_validator']['wadl'],
    dot_output: node['repose']['api_validator']['dot_output'],
    enable_rax_roles: node['repose']['api_validator']['enable_rax_roles'],
    enable_api_coverage: node['repose']['api_validator']['enable_api_coverage'],
    check_well_formed: node['repose']['api_validator']['check_well_formed'],
    check_grammars: node['repose']['api_validator']['check_grammars'],
    check_elements: node['repose']['api_validator']['check_elements'],
    check_plain_params: node['repose']['api_validator']['check_plain_params'],
    do_xsd_grammar_transform: node['repose']['api_validator']['do_xsd_grammar_transform'],
    enable_pre_process_extension: node['repose']['api_validator']['enable_pre_process_extension'],
    remove_dups: node['repose']['api_validator']['remove_dups'],
    xpath_version: node['repose']['api_validator']['xpath_version'],
    xsl_engine: node['repose']['api_validator']['xsl_engine'],
    xsd_engine: node['repose']['api_validator']['xsd_engine'],
    mask_rax_roles_403: node['repose']['api_validator']['mask_rax_roles_403'],
    join_xpath_checks: node['repose']['api_validator']['join_xpath_checks'],
    enable_ignore_xsd_extension: node['repose']['api_validator']['enable_ignore_xsd_extension'],
    validator_name: node['repose']['api_validator']['validator_name'],
    validate_checker: node['repose']['api_validator']['validate_checker'],
    check_headers: node['repose']['api_validator']['check_headers']
  )
  notifies :restart, 'service[repose-valve]'
end
