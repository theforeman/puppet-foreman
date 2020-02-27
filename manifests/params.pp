# The foreman default parameters
class foreman::params {
  $lower_fqdn = downcase($::fqdn)

  # Basic configurations
  $foreman_url      = "https://${lower_fqdn}"
  # Should foreman act as an external node classifier (manage puppet class
  # assignments)
  # should foreman manage host provisioning as well
  $unattended     = true
  $unattended_url = undef
  # configure foreman via apache
  $apache         = true
  # configure apache with passenger
  $passenger      = true
  # Server name of the VirtualHost
  $servername     = $::fqdn
  # Server aliases of the VirtualHost
  $serveraliases  = [ 'foreman' ]
  # force SSL (note: requires apache)
  $ssl            = true
  # further passenger parameters
  $passenger_prestart = true
  $passenger_min_instances = 1
  $passenger_start_timeout = 90

  # Additional software repos
  $configure_epel_repo      = ($::osfamily == 'RedHat' and $::operatingsystem != 'Fedora')
  # Only configure extra SCL repos on EL
  $configure_scl_repo       = ($::osfamily == 'RedHat' and $::operatingsystem != 'Fedora')

  # Advanced configuration
  # this can be a version or nightly
  $repo              = undef
  $app_root          = '/usr/share/foreman'
  $plugin_config_dir = '/etc/foreman/plugins'
  $manage_user       = true
  $user              = 'foreman'
  $group             = 'foreman'
  $user_groups       = ['puppet']
  $rails_env         = 'production'
  $gpgcheck          = true
  $version           = 'present'
  $plugin_version    = 'present'

  $cors_domains = []

  # if enabled, will install and configure the database server on this host
  $db_manage   = true
  # Database 'production' settings
  $db_username = 'foreman'
  # Generate and cache the password on the master once
  # In multi-puppetmaster setups, the user should specify their own
  $db_password = extlib::cache_data('foreman_cache_data', 'db_password', extlib::random_password(32))
  # Default database connection pool
  $db_pool = 5
  # if enabled, will run rake jobs, which depend on the database
  $db_manage_rake = true

  # Configure foreman email settings (database or email.yaml)
  $email_delivery_method     = undef
  $email_smtp_address        = undef
  $email_smtp_port           = 25
  $email_smtp_domain         = undef
  $email_smtp_authentication = 'none'
  $email_smtp_user_name      = undef
  $email_smtp_password       = undef

  # Telemetry
  $telemetry_prefix             = 'fm_rails'
  $telemetry_prometheus_enabled = false
  $telemetry_statsd_enabled     = false
  $telemetry_statsd_host        = '127.0.0.1:8125'
  $telemetry_statsd_protocol    = 'statsd'
  $telemetry_logger_enabled     = false
  $telemetry_logger_level       = 'DEBUG'

  # Configure how many workers should Dynflow use
  $dynflow_pool_size = 5

  # Define foreman service
  $foreman_service = 'foreman'
  $foreman_service_ensure = 'running'
  $foreman_service_enable = true
  $foreman_service_port = 3000
  $foreman_service_puma_threads_min = 0
  $foreman_service_puma_threads_max = 16
  $foreman_service_puma_workers = 2

  # Define job processing service properties
  $jobs_manage_service = true
  $jobs_service_ensure = 'running'
  $jobs_service_enable = true
  $jobs_sidekiq_redis_url = undef

  # Keycloak
  $keycloak = false
  $keycloak_app_name = 'foreman-openidc'
  $keycloak_realm = 'ssl-realm'

  $hsts_enabled = true

  # OS specific paths
  case $::osfamily {
    'RedHat': {
      # We use system packages except on EL7
      if versioncmp($facts['operatingsystemmajrelease'], '8') >= 0 {
        $passenger_ruby = undef
        $passenger_ruby_package = undef
        $plugin_prefix = 'rubygem-foreman_'
      } else {
        $passenger_ruby = '/usr/bin/tfm-ruby'
        $passenger_ruby_package = 'tfm-rubygem-passenger-native'
        $plugin_prefix = 'tfm-rubygem-foreman_'
      }
    }
    'Debian': {
      $passenger_ruby = '/usr/bin/foreman-ruby'
      $passenger_ruby_package = undef
      $plugin_prefix = 'ruby-foreman-'
    }
    'Linux': {
      case $::operatingsystem {
        'Amazon': {
          # add passenger::install::scl as EL uses SCL on Foreman 1.2+
          $passenger_ruby = '/usr/bin/tfm-ruby'
          $passenger_ruby_package = 'tfm-rubygem-passenger-native'
          $plugin_prefix = 'tfm-rubygem-foreman_'
        }
        default: {
          fail("${::hostname}: This module does not support operatingsystem ${::operatingsystem}")
        }
      }
    }
    default: {
      fail("${::hostname}: This module does not support osfamily ${::osfamily}")
    }
  }

  if $::rubysitedir =~ /\/opt\/puppetlabs\/puppet/ {
    $puppet_ssldir = '/etc/puppetlabs/puppet/ssl'
  } else {
    $puppet_ssldir = '/var/lib/puppet/ssl'
  }

  # If CA is specified, remote Foreman host will be verified in reports/ENC scripts
  $client_ssl_ca   = "${puppet_ssldir}/certs/ca.pem"
  # Used to authenticate to Foreman, required if require_ssl_puppetmasters is enabled
  $client_ssl_cert = "${puppet_ssldir}/certs/${lower_fqdn}.pem"
  $client_ssl_key  = "${puppet_ssldir}/private_keys/${lower_fqdn}.pem"

  $vhost_priority = '05'

  # Set these values if you want Passenger to serve a CA-provided cert instead of puppet's
  $server_ssl_ca    = "${puppet_ssldir}/certs/ca.pem"
  $server_ssl_chain = "${puppet_ssldir}/certs/ca.pem"
  $server_ssl_cert  = "${puppet_ssldir}/certs/${lower_fqdn}.pem"
  $server_ssl_certs_dir = '' # lint:ignore:empty_string_assignment - this must be empty since we override a default
  $server_ssl_key   = "${puppet_ssldir}/private_keys/${lower_fqdn}.pem"
  $server_ssl_crl   = "${puppet_ssldir}/crl.pem"
  $server_ssl_protocol = undef
  $server_ssl_verify_client = 'optional'

  # We need the REST API interface with OAuth for some REST Puppet providers
  $oauth_active = true
  $oauth_map_users = false
  $oauth_consumer_key = extlib::cache_data('foreman_cache_data', 'oauth_consumer_key', extlib::random_password(32))
  $oauth_consumer_secret = extlib::cache_data('foreman_cache_data', 'oauth_consumer_secret', extlib::random_password(32))

  # Initial admin account details
  $initial_admin_username = 'admin'
  $initial_admin_password = extlib::cache_data('foreman_cache_data', 'admin_password', extlib::random_password(16))
  $initial_admin_first_name = undef
  $initial_admin_last_name = undef
  $initial_admin_email = undef
  $initial_admin_locale = undef
  $initial_admin_timezone = undef

  # Initial taxonomies
  $initial_organization = undef
  $initial_location = undef

  $ipa_authentication = false
  $http_keytab = '/etc/httpd/conf/http.keytab'
  $pam_service = 'foreman'
  $ipa_manage_sssd = true

  # Websockets
  $websockets_encrypt = true
  $websockets_ssl_key = $server_ssl_key
  $websockets_ssl_cert = $server_ssl_cert

  # Application logging
  $logging_level = 'info'
  $logging_type = 'file'
  $logging_layout = 'pattern'
  $loggers = {}

  # Default ports for Apache to listen on
  $server_port     = 80
  $server_ssl_port = 443

}
