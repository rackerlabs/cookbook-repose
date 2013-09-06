# repose cookbook

This cookbook manages Repose.

"REPOSE is an open-source RESTful HTTP proxy service that scales to the cloud. REPOSE provides the solution to common API processing tasks such as rate limiting, client authentication, versioning, and logging so that web service developers can focus on the unique features of their services." ~ http://openrepose.org/, 09/03/2013

# Requirements

Supports CentOS 6.4, Ubuntu 10.04, and Ubuntu 12.04.

# Usage

Include `recipe[repose]` in your run_list and override attributes as required.

There are 2 ways to setup filters. The first is to include any of the `repose::filter-*` recipes *before* the `repose::default` recipe. The second is to add the filter names to the `node['repose']['filters']` array. You choose.

# Attributes

## General attributes

* `node['repose']['owner']` - The Repose user. `root` on Ubuntu and `repose` on CentOS.
* `node['repose']['group']` - The Repose primary group. `root` on Ubuntu and `repose` on CentOS.
* `node['repose']['loglevel']` - The log level for the main Repose log file.
* `node['repose']['cluster_id']` - The cluster ID.
* `node['repose']['node_id']` - The node ID.
* `node['repose']['port']` - The port to bind to.
* `node['repose']['connection_timeout']` - The connection timeout in ms.
* `node['repose']['read_timeout']` The read timeout in ms.
* `node['repose']['deploy_auto_clean']` - Auto-clean the deploy directory if `true`.
* `node['repose']['filter_check_interval']` - The filter check interval in ms.
* `node['repose']['filters']` - An array of filters to load. Loading the `repose::filter-*` recipes will update this if required.

## Peer attributes

* `node['repose']['peer_search_enabled']` - The `repose::default` recipe loads the `repose::load_peers` recipe if `true`.
* `node['repose']['peer_search_role']` - The role to use to search for Repose peers with. Also uses the Chef environment and cluster ID.
* `node['repose']['peers']` - An array of Repose peers.

The Repose peers array defaults to:
```
[
  { 'id' => 'repose_node1',
    'hostname' => 'localhost',
    'port' => 8080,
  }
]
```

## Endpoint attributes

* `node['repose']['endpoints']` - An array of Repose endponts.

The Repose endpoints array defaults to:
```
[
  { 'id' => 'open_repose',
    'protocol' => 'http',
    'hostname' => 'openrepose.org',
    'port' => 80,
    'root_path' => '/',
    'default' => true,
  }
]
```

## dist-datastore attributes

* `node['repose']['dist_datastore']['allow_all']` - Allow all hosts to use the dist-datastore if `true`. Be aware that this basically turns off security around the dist-datastore. Use with care.
* `node['repose']['dist_datastore']['allowed_hosts']` - An array of hosts to whitelist for the dist-datastore.

## http-logging attributes

* `node['repose']['http_logging']['id']` - The log ID.
* `node['repose']['http_logging']['format']` - The log format.
* `node['repose']['http_logging']['logfile']` - The log file.

## ip-identity attributes

* `node['repose']['ip_identity']['quality']` - The default quality.
* `node['repose']['ip_identity']['white_list_quality']` - The whitelist quality.
* `node['repose']['ip_identity']['white_list_ip_addresses']` - An array of whitelisted IP addresses.

# Recipes

## default

Installs and configures Repose. May include all other recipes.

## install

Install Repose only. Loads the appropriate install recipe based on platform family. This recipe is not meant to be used directly.

## install_debian

Install Repose on the Debian family of systems. This recipe is not meant to be used directly.

## install_rhel

Install Repose on the RHEL family of systems. This recipe is not meant to be used directly.

## load_peers

Uses chef-search to find nodes with a matching Chef environment, search role, and cluster ID, maps them to hashes representing Repose peers, and loads them into the `node['repose']['peers']` array. Not meant to be called directly unless a different cookbook wants to find Repose nodes. E.g. maybe Nginx uses Repose nodes as a backend and wants to consume `node['repose']['peers']`.

## filter-dist-datastore

Setup the dist-datastore filter. *Must* be called before `repose::default`.

## filter-http-logging

Setup the http-logging filter. *Must* be called before `repose::default`.

## filter-ip-identity

Setup the ip-identity filter. *Must* be called before `repose::default`.

# Vagrant

This cookbook includes support for Vagrant. Start the VM by following these steps

1. Install [VirtualBox](https://www.virtualbox.org/wiki/Downloads)
2. Install [Vagrant](http://downloads.vagrantup.com/)
3. Run `bundle install`
4. Run `vagrant plugin install vagrant-berkshelf`
5. Run `vagrant plugin install vagrant-omnibus`
6. Run `vagrant up`

# Tests

This cookbook includes support for test-kitchen and minitest. Run the test suite with

```
kitchen test
```

# Author

* Author:: Brendan ODonnell (<brendan.odonnell@rackspace.com>)
* Author:: Rackspace (<identity@rackspace.com>)
