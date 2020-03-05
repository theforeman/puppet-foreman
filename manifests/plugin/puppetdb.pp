# @summary Install the puppetdb_foreman plugin
#
# @param address
#   Address of puppetdb API.
#
# @param ssl_ca_file
#   CA certificate file which will be used to connect to the PuppetDB API.
#
# @param ssl_certificate
#   Certificate file which will be used to connect to the PuppetDB API.
#
# @param ssl_private_key
#   Private key file which will be used to connect to the PuppetDB API.
#
# @param api_version
#   PuppetDB API version.
#
class foreman::plugin::puppetdb (
  Stdlib::HTTPUrl $address = 'https://localhost:8081/pdb/cmd/v1',
  String $ssl_ca_file = $foreman::params::client_ssl_ca,
  String $ssl_certificate = $foreman::params::client_ssl_cert,
  String $ssl_private_key = $foreman::params::client_ssl_key,
  Enum['1', '3', '4'] $api_version = '4',
) inherits foreman::params {
  foreman::plugin { 'puppetdb':
    package => $foreman::plugin_prefix.regsubst(/foreman[_-]/, 'puppetdb_foreman'),
  }
  -> foreman_config_entry { 'puppetdb_enabled':
    value => true,
  }
  -> foreman_config_entry { 'puppetdb_address':
    value => $address,
  }
  -> foreman_config_entry { 'puppetdb_ssl_ca_file':
    value => $ssl_ca_file,
  }
  -> foreman_config_entry { 'puppetdb_ssl_certificate':
    value => $ssl_certificate,
  }
  -> foreman_config_entry { 'puppetdb_ssl_private_key':
    value => $ssl_private_key,
  }
  -> foreman_config_entry { 'puppetdb_api_version':
    value => $api_version,
  }
}
