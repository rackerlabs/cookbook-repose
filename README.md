# repose cookbook

This cookbook manages Repose.

"REPOSE is an open-source RESTful HTTP proxy service that scales to the cloud. REPOSE provides the solution to common API processing tasks such as rate limiting, client authentication, versioning, and logging so that web service developers can focus on the unique features of their services." ~ http://openrepose.org/, 09/03/2013

# Requirements

Supports CentOS 6.4, Ubuntu 10.04, and Ubuntu 12.04.

Requires Repose v6.2.0 or greater due to package differences.

# Usage

Include `recipe[repose]` in your run_list and override attributes as required.

## Filters

There are 2 ways to setup filters:
  1. Include any of the `repose::filter-*` recipes *before* the `repose::default` recipe
  2. Add the filter names to the `node['repose']['filters']` array

Available filters are:
  * client-auth
  * ip-identity
  * rate-limiting
  * slf4j-http-logging
  * header-translation
  * DeRP
  * header-normalization
  * [content-type-stripper](https://repose.atlassian.net/wiki/display/REPOSE/Content+Type+Stripper+filter) (system-model only)
  * [translation](https://repose.atlassian.net/wiki/display/REPOSE/Translation+filter)
  * [rackspace-auth-user](https://repose.atlassian.net/wiki/display/REPOSE/Rackspace+Auth+User+filter)
  * [header-identity](https://repose.atlassian.net/wiki/display/REPOSE/Header+Identity+filter)
  * [uri-identity](https://repose.atlassian.net/wiki/display/REPOSE/URI+Identity+filter)

Other filters are available in Repose and may be added to this cookbook in a later revision.

## Services

Services work the same way as filters. Just s/filter/service/g.

Available services are:
  * connection-pool (configuration only)
  * dist-datastore

## Nodes

There are also 2 ways to setup nodes in `system-model.cfg.xml`:
  1. Override the `node['repose']['peers']` array as shown below. Note that peers without a `cluster_id` are assumed to belong to all clusters. This is almost certainly not correct if more than 1 cluster is being configured but is implemented to maintain functionality with earlier versions of the cookbook.
  2. Set `node['repose']['peer_search_enabled']` to `true`. For each Chef node found this way peers will be loaded according to the `node['repose']['cluster_ids']`, `node['repose']['node_id']`, `node['fqdn']`, `node['repose']['port']`, and `node['repose']['ssl_port']` attributes. `node_id` and `fqdn` will be consistant for each `cluster_id` in `cluster_ids`. `port` and `ssl_port` will be incremented by 1 for each `cluster_id` in `cluster_ids`.

## Endpoints

Setup endpoint in `system-model.cfg.xml` by overriding the `node['repose']['endpoints']` array as shown below. Note that endpoints without a `cluster_id` are assumed to belong to all clusters. This is almost certainly not correct if more than 1 cluster is being configured but is implemented to maintain functionality with earlier versions of the cookbook.

# Attributes

## General attributes

* `node['repose']['owner']` - The Repose user. `root` on Ubuntu and `repose` on CentOS.
* `node['repose']['group']` - The Repose primary group. `root` on Ubuntu and `repose` on CentOS.
* `node['repose']['install_opts']` - Command line options used for installing pacakges.
* `node['repose']['loglevel']` - The log level for the main Repose log file.
* `node['repose']['cluster_ids']` - An array of cluster IDs.
* `node['repose']['node_id']` - The node ID.
* `node['repose']['port']` - The port to bind to.
* `node['repose']['ssl_port']` - The SSL port to bind to.
* `node['repose']['config_directory']` - Configuration directory location.
* `node['repose']['log_path']` - Log directory location.
* `node['repose']['pid_file']` - PID file location.
* `node['repose']['java_opts']` - Java options specific to Repose. This is distinct from the system environmment variable `JAVA_OPTS`.
* `node['repose']['shutdown_port']` - The shutdown port to bind to.
* `node['repose']['connection_timeout']` - The connection timeout in ms.
* `node['repose']['read_timeout']` The read timeout in ms.
* `node['repose']['deploy_auto_clean']` - Auto-clean the deploy directory if `true`.
* `node['repose']['filter_check_interval']` - The filter check interval in ms.
* `node['repose']['filters']` - An array of filters to load. Loading the `repose::filter-*` recipes will update this if required.
* `node['repose']['services']` - An array of services to load. Loading the `repose::service-*` recipes will update this if required.

## Repository attributes

* `node['repose']['repo']['managed']` - Whether or not to manage the Repose repository. If `false` the recipes will assume the Repose repository is already configured.
* `node['repose']['repo']['baseurl']` - The base URL of the Repose repository.
* `node['repose']['repo']['gpgkey']` - The GPG key used to sign Repose packages.
* `node['repose']['repo']['gpgcheck']` - Whether or not to check package signatures. `rhel` only.
* `node['repose']['repo']['enabled']` - Whether or not the repository is enabled by default. `rhel` only.

These attributes should have reasonable, platform_family specific defaults.

## Peer attributes

* `node['repose']['peer_search_enabled']` - The `repose::default` recipe loads the `repose::load_peers` recipe if `true`.
* `node['repose']['peer_search_query']` - The query to use to search for Repose peers.
* `node['repose']['peers']` - An array of Repose peers.

The Repose peers array defaults to:
```
[
  { 'cluster_id' => 'repose',
    'id' => 'repose_node1',
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
  { 'cluster_id' => 'repose',
    'id' => 'open_repose',
    'protocol' => 'http',
    'hostname' => 'openrepose.org',
    'port' => 80,
    'root_path' => '/',
    'default' => true,
  }
]
```

## dist-datastore attributes

* `node['repose']['dist_datastore']['cluster_id']` - An array of cluster IDs that use this service or `['all']` for all cluster IDs.
* `node['repose']['dist_datastore']['allow_all']` - Allow all hosts to use the dist-datastore if `true`. Be aware that this basically turns off security around the dist-datastore. Use with care.
* `node['repose']['dist_datastore']['allowed_hosts']` - An array of hosts to whitelist for the dist-datastore.
* `node['repose']['dist_datastore']['port']` - The port to use for dist-datastore. Set to `nil` to leave out the `<port-config>` block. Will be incremented by 1 for each `cluster_id` in `node['repose']['cluster_ids']`.

## slf4j-http-logging attributes

* `node['repose']['slf4j_http_logging']['cluster_id']` - An array of cluster IDs that use this filter or `['all']` for all cluster IDs.
* `node['repose']['slf4j_http_logging']['id']` - The log ID.
* `node['repose']['slf4j_http_logging']['format']` - The log format.

## ip-identity attributes

* `node['repose']['ip_identity']['cluster_id']` - An array of cluster IDs that use this filter or `['all']` for all cluster IDs.
* `node['repose']['ip_identity']['quality']` - The default quality.
* `node['repose']['ip_identity']['white_list_quality']` - The whitelist quality.
* `node['repose']['ip_identity']['white_list_ip_addresses']` - An array of whitelisted IP addresses.

## client-auth attributes

* `node['repose']['client_auth']['cluster_id']` - An array of cluster IDs that use this filter or `['all']` for all cluster IDs.
* `node['repose']['client_auth']['auth_provider']` - The authentication provider to use, either 'RACKSPACE' for Rackspace cloud, or else 'OPENSTACK' for Keystone
* `node['repose']['client_auth']['username_admin']` - Administrator username making auth-n requests for clients.
* `node['repose']['client_auth']['password_admin']` - Administrator password making auth-n requests for clients.
* `node['repose']['client_auth']['auth_uri']` - URI for the authentication service.
* `node['repose']['client_auth']['tenanted']` - Whether the tenant_id will be parsed from the request uri.  If this is set to true then mapping_regex must be provided.
* `node['repose']['client_auth']['mapping_regex']` - Optional regex to extract the user/tenant/account information from URI.
    * For example this regex `.*/v1/([-|\w]+)/?.*` will provide this action: '/v1/853473/action => x-pp-user=853473'. Used with the 'CLOUD' Rackspace mapping_type below.
    * For example this regex `.*.com/service/([-|\w]+)/?.*` will provide this action: '/service/853473/action => x-pp-user=853473'. Used with the 'MOSSO' Rackspace mapping_type below.
* `node['repose']['client_auth']['mapping_type']` - (Rackspace only, required if 'mapping_regex' is provided) One of 'CLOUD' or 'MOSSO'.
* `node['repose']['client_auth']['tenant_id']` - (Keystone only, optional) Tenant-ID with admin role for the admin user above.
* `node['repose']['client_auth']['delegable']` - Whether auth is delegable.

* `node['repose']['client_auth']['request_groups']` - Whether repose requests the user's list of groups from the identity service.
* `node['repose']['client_auth']['token_cache_timeout']` - Timeout for token cache.
* `node['repose']['client_auth']['group_cache_timeout']` - Timeout for group cache.
* `node['repose']['client_auth']['endpoints_in_header']` - Enable or disable the listing of service endpoints in the header.

* `node['repose']['client_auth']['white_list']` - You can configure Repose authentication to allow the processing of requests that do not require authentication. Default to `false`.
* `node['repose']['client_auth']['uri_regex']` - The whitelist contains a list of regular expressions Repose will attempt to match against the full request URI. If the URI matches a regular expression on the white list, the request is passed to the origin service. Otherwise, authentication is performed against the request.

## rate-limit attributes

* `node['repose']['rate_limiting']['cluster_id']` - An array of cluster IDs that use this filter or `['all']` for all cluster IDs.
* `node['repose']['rate_limiting']['uri_regex']` - A regular expression (regex) for the URI at which the user can query their limits.
* `node['repose']['rate_limiting']['include_absolute_limits']` - Enables or disables integration with absolute limits.
* `node['repose']['rate_limiting']['limit_groups']` - An array of limit groups.

The limit groups array defaults to:
```
[
  { 'id' => 'limited',
    'groups' => 'limited',
    'default' => true,
    'limits' => [
      { 'id' => 'all',
        'uri' => '*',
        'uri-regex' => '/.*',
        'http-methods' => 'POST PUT GET DELETE',
        'unit' => 'MINUTE',
        'value' => 10
      }
    ]
  },
  { 'id' => 'unlimited',
    'groups' => 'unlimited',
    'default' => false,
    'limits' => []
  }
]
```

## header-translation attributes

* `node['repose']['header_translation']['headers']` - header list of original headers (the ones passed in the request) and the new headers (the ones that will have duplicate values of original headers).  new_name can be a list of headers white-space separated. You can also set an optional remove_attribute key if you'd like the original header to be removed.  to set the array. 

The default headers are:
```
[
  { 'original_name' => 'Content-Type',
    'new_name' => 'rax-content-type'
  },
  { 'original_name' => 'Content-Length',
    'new_name' => 'rax-content-length not-rax-content-length something-else',
    'remove_original' => true
  }
]
```

## header-identity attributes

* `node['repose']['header_identity']['cluster_id']` - An array of cluster IDs that use this filter or `['all']` for all cluster IDs.
* `node['repose']['header_identity']['headers']` - Lists the headers to identify the incoming user.

The default headers are:
```
[
  { 'id' => 'X-Auth-Token',
    'quality' => 0.95
  },
  { 'id' => 'X-Forwarded-For',
    'quality' => 0.5
  }
]
```

## header-normalization attributes

* `node['repose']['header_normalization']['whitelist']` - a hash of whitelist blocks, each encapsulating an array of headers to be whitelisted by Repose for delivery to the origin service or next filter in the chain. A unique 'id' key identifies each whitelist entry, with optional 'uri_regex' and 'http_methods' keys to induce further constraints. 
* `node['repose']['header_normalization']['blacklist']` - a hash of blacklist blocks, each encapsulating an array of headers to be blacklisted by Repose for non-delivery to the origin service or next filter in the chain. A unique 'id' key identifies each blacklist entry, with optional 'uri_regex' and 'http_methods' keys to induce further constraints. 

The default whitelist is:
```
[
  { 'id' => 'credentials',
    'uri_regex' => '/servers/(.*)',
    'headers'   => ['X-Auth-Key','X-Auth-User']
  },
  { 'id' => 'modification',
    'uri_regex' => '/resource/(.*)',
    'http_methods' => 'PUT POST',
    'headers'   => ['X-Modify']
  }
]
```

The default blacklist is:
```
[
  { 'id' => 'rate-limit-headers',
    'headers'   => ['X-PP-User','X-PP-Groups']
  }
]
```

## content-type-stripper attributes

* `node['repose']['content_type_stripper']['cluster_id']` - An array of cluster IDs that use this filter or `['all']` for all cluster IDs.

## connection-pool attributes

* `node['repose']['connection_pool']['chunked_encoding']` - Use the default unless your programming language does not support chunked encoding. Some Repose filters modify request bodies. Due to this possibility Repose will, by default, send requests with entities as chunked. Setting chunked-encoding to false will cause Repose to attempt to evaluate the actual content length of the request by reading the ServletInputStream. Default is true.
* `node['repose']['connection_pool']['max_total']` - Maximum number of connections that Repose opens across all endpoints. (If set too high, you might run out of memory.) Default is 400.
* `node['repose']['connection_pool']['max_per_route']` - Maximum number of connections that Repose opens per endpoint. Default is 200.
* `node['repose']['connection_pool']['socket_timeout']` - Number of milliseconds a request is in flight before it times out. Default is 30000.
* `node['repose']['connection_pool']['connection_timeout']` - Number of milliseconds a connection waits to send a request. Default is 30000.
* `node['repose']['connection_pool']['socket_buffer_size']` - Default is 8192.
* `node['repose']['connection_pool']['connection_max_line_length']` - Default is 8192.
* `node['repose']['connection_pool']['connection_max_header_count']` - Maximum number of headers that can be sent in the request. Default is 100.
* `node['repose']['connection_pool']['connection_max_status_line_garbage']` - Maximum number of lines allotted for garbage. Default is 100.
* `node['repose']['connection_pool']['tcp_nodelay']` - Default is true.
* `node['repose']['connection_pool']['keepalive_timeout']` - If a Keep-Alive header is not present in the response, the value of keepalive.timeout is evaluated. If this value is 0, the connection will be kept alive indefinitely. If the value is greater than 0, the connection will be kept alive for the number of milliseconds specified. Set to 1 to connect:close. Default is 0.

## translation attributes

* `node['repose']['translation']['cluster_id']` - An array of cluster IDs that use this filter or `['all']` for all cluster IDs.
* `node['repose']['translation']['request_translations']` - Enumerated translations that specify a chain of stylesheets to be applied to a request request body and the criteria for when the chain should be applied.
* `node['repose']['translation']['response_translations']` - Enumerated translations that specify a chain of stylesheets to be applied to a request response body and the criteria for when the chain should be applied.

The default values for request\_translations and response\_translations are `[]` because no sensable examples exist for a generic origin service. See the online documentation for configuration examples.

## rackspace-auth-user attributes

* `node['repose']['rackspace_auth_user']['cluster_id']` - An array of cluster IDs that use this filter or `['all']` for all cluster IDs.
* `node['repose']['rackspace_auth_user']['v1_1']['enabled']` - Specifies whether version 1.1 of the Rackspace identity contract should be parsed.
* `node['repose']['rackspace_auth_user']['v1_1']['read_limit']` - Specifies the size of the content.
* `node['repose']['rackspace_auth_user']['v1_1']['group']` - Defines the X-PP Groups header for this filter.
* `node['repose']['rackspace_auth_user']['v1_1']['quality']` - Defines the quality assigned to the header.
* `node['repose']['rackspace_auth_user']['v2_0']['enabled']` - Specifies whether version 2.0 of the Rackspace identity contract should be parsed.
* `node['repose']['rackspace_auth_user']['v2_0']['read_limit']` - Specifies the size of the content.
* `node['repose']['rackspace_auth_user']['v2_0']['group']` - Defines the X-PP Groups header for this filter.
* `node['repose']['rackspace_auth_user']['v2_0']['quality']` - Defines the quality assigned to the header.

## uri-identity attributes

* `node['repose']['uri_identity']['cluster_id']` - An array of cluster IDs that use this filter or `['all']` for all cluster IDs.
* `node['repose']['uri_identity']['mappings']` - An array of regular expressions used to extract the identification information from the request URI.
* `node['repose']['uri_identity']['group']` - Names the rate limiting group associated with the extracted identification data.
* `node['repose']['uri_identity']['quality']` - Defines the quality assigned to user by the incoming identification data.

The default mappings are:
```
[
  '.*/servers/(\w*)/.*',
  '.*/servers/(\w*)/.*'
]
```

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

## filter-* or service-*

Setup a paticular filter or service. *Must* be called before `repose::default`.

# Vagrant

This cookbook includes support for Vagrant. Start the VM by following these steps

1. Install [VirtualBox](https://www.virtualbox.org/wiki/Downloads)
2. Install [Vagrant](http://downloads.vagrantup.com/)
3. Run `bundle install`
4. Run `vagrant plugin install vagrant-berkshelf`
5. Run `vagrant plugin install vagrant-omnibus`
6. Run `vagrant up`

# Tests

Run the Ruby linter with
```
rubocop --config .rubocop_todo.yml
```

This cookbook includes support for test-kitchen and minitest. Run the test suite with

```
kitchen test
```

# Author(s)

* Author: Brendan ODonnell (<brendan.odonnell@rackspace.com>)
* Author: Nick Silkey (<nick.silkey@rackspace.com>)
* Author: Dimitry Ushakov  (<dimitry.ushakov@rackspace.com>)
