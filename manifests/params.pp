# @summary The foreman default parameters
# @api private
class foreman::params inherits foreman::globals {
  $lower_fqdn = downcase($facts['networking']['fqdn'])

  # Basic configurations
  $foreman_url      = "https://${lower_fqdn}"
  # Server name of the VirtualHost
  $servername     = $facts['networking']['fqdn']

  # Advanced configuration
  $plugin_config_dir = '/etc/foreman/plugins'

  # Generate and cache the password on the master once
  # In multi-puppetmaster setups, the user should specify their own
  $db_password = extlib::cache_data('foreman_cache_data', 'db_password', extlib::random_password(32))

  # Define foreman service
  $foreman_service = 'foreman'

  # OS specific paths
  case $facts['os']['family'] {
    'RedHat': {
      # We use system packages except on EL7
      if versioncmp($facts['os']['release']['major'], '8') >= 0 {
        $passenger_ruby_package = undef
        $_plugin_prefix = 'rubygem-foreman_'
        $configure_scl_repo = false
      } else {
        $passenger_ruby_package = 'tfm-rubygem-passenger-native'
        $_plugin_prefix = 'tfm-rubygem-foreman_'
        $configure_scl_repo = true
      }

      $user_shell = '/sbin/nologin'
    }
    'Debian': {
      $passenger_ruby_package = undef
      $_plugin_prefix = 'ruby-foreman-'
      $configure_scl_repo = false
      $user_shell = '/usr/sbin/nologin'
    }
    'Linux': {
      case $facts['os']['name'] {
        'Amazon': {
          $passenger_ruby_package = 'tfm-rubygem-passenger-native'
          $_plugin_prefix = 'tfm-rubygem-foreman_'
          $configure_scl_repo = true
          $user_shell = '/sbin/nologin'
        }
        default: {
          fail("${facts['networking']['hostname']}: This module does not support operatingsystem ${facts['os']['name']}")
        }
      }
    }
    default: {
      fail("${facts['networking']['hostname']}: This module does not support osfamily ${facts['os']['family']}")
    }
  }
  $plugin_prefix = pick($foreman::globals::plugin_prefix, $_plugin_prefix)

  if fact('aio_agent_version') =~ String[1] {
    $puppet_ssldir = '/etc/puppetlabs/puppet/ssl'
  } else {
    $puppet_ssldir = '/var/lib/puppet/ssl'
  }

  # If CA is specified, remote Foreman host will be verified in reports/ENC scripts
  $client_ssl_ca   = "${puppet_ssldir}/certs/ca.pem"
  # Used to authenticate to Foreman, required if require_ssl_puppetmasters is enabled
  $client_ssl_cert = "${puppet_ssldir}/certs/${lower_fqdn}.pem"
  $client_ssl_key  = "${puppet_ssldir}/private_keys/${lower_fqdn}.pem"

  # Set these values if you want Apache to serve a CA-provided cert instead of puppet's
  $server_ssl_ca    = "${puppet_ssldir}/certs/ca.pem"
  $server_ssl_chain = "${puppet_ssldir}/certs/ca.pem"
  $server_ssl_cert  = "${puppet_ssldir}/certs/${lower_fqdn}.pem"
  $server_ssl_key   = "${puppet_ssldir}/private_keys/${lower_fqdn}.pem"
  $server_ssl_crl   = "${puppet_ssldir}/crl.pem"

  # We need the REST API interface with OAuth for some REST Puppet providers
  $oauth_consumer_key = extlib::cache_data('foreman_cache_data', 'oauth_consumer_key', extlib::random_password(32))
  $oauth_consumer_secret = extlib::cache_data('foreman_cache_data', 'oauth_consumer_secret', extlib::random_password(32))
  $oauth_effective_user = 'admin'

  # Initial admin account details
  $initial_admin_password = extlib::cache_data('foreman_cache_data', 'admin_password', extlib::random_password(16))
}
