# = PuppetDB Foreman plugin
#
# Installs the puppetdb_foreman plugin
#
# === Parameters:
#
# $package::           Package name to install
#
# $address::           Address of puppetdb API.
#                      Defaults to 'https://localhost:8081/pdb/cmd/v1'
#
# $ssl_ca_file::       CA certificate file which will be used to connect to the PuppetDB API.
#                      Defaults to client_ssl_ca
#
# $ssl_certificate::   Certificate file which will be used to connect to the PuppetDB API.
#                      Defaults to client_ssl_cert
#
# $ssl_private_key::   Private key file which will be used to connect to the PuppetDB API.
#                      Defaults to client_ssl_key
#
# $api_version::       PuppetDB API version.
#                      Defaults to '4'
#
class foreman::plugin::puppetdb (
  String $package = $::foreman::plugin::puppetdb::params::package,
  Stdlib::HTTPUrl $address = $::foreman::plugin::puppetdb::params::address,
  String $ssl_ca_file = $::foreman::plugin::puppetdb::params::ssl_ca_file,
  String $ssl_certificate = $::foreman::plugin::puppetdb::params::ssl_certificate,
  String $ssl_private_key = $::foreman::plugin::puppetdb::params::ssl_private_key,
  Enum['1', '3', '4'] $api_version = '4',
) inherits foreman::plugin::puppetdb::params {
  foreman::plugin { 'puppetdb':
    package => $package,
  }

  $config = {
    'puppetdb_enabled'         => true,
    'puppetdb_address'         => $address,
    'puppetdb_ssl_ca_file'     => $ssl_ca_file,
    'puppetdb_ssl_certificate' => $ssl_certificate,
    'puppetdb_ssl_private_key' => $ssl_private_key,
    'puppetdb_api_version'     => $api_version,
  }

  $config.each |$setting, $value| {
    foreman_config_entry { $setting:
      value   => $value,
      require => Class['foreman::database'],
    }
  }
}
