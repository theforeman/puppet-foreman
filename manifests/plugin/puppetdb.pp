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
# @param ensure
#    Specify the package state, or absent/purged to remove it
#
class foreman::plugin::puppetdb (
  Optional[String[1]] $ensure = undef,
  Stdlib::HTTPUrl $address = 'https://localhost:8081/pdb/cmd/v1',
  String $ssl_ca_file = $foreman::params::client_ssl_ca,
  String $ssl_certificate = $foreman::params::client_ssl_cert,
  String $ssl_private_key = $foreman::params::client_ssl_key,
  Enum['1', '3', '4'] $api_version = '4',
) inherits foreman::params {
  foreman::plugin { 'puppetdb':
    version => $ensure,
    package => $foreman::params::plugin_prefix.regsubst(/foreman[_-]/, 'puppetdb_foreman'),
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
