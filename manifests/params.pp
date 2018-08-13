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
  # Enable users authentication (default user:admin pw:changeme)
  $authentication = true
  # configure foreman via apache and passenger
  $passenger      = true
  # Enclose apache configuration in <VirtualHost>...</VirtualHost>
  $use_vhost      = true
  # Server name of the VirtualHost
  $servername     = $::fqdn
  # Server aliases of the VirtualHost
  $serveraliases  = [ 'foreman' ]
  # force SSL (note: requires passenger)
  $ssl            = true
  #define which interface passenger should listen on, undef means all interfaces
  $passenger_interface = undef
  # further passenger parameters
  $passenger_prestart = true
  $passenger_min_instances = 1
  $passenger_start_timeout = 90
  # Choose whether you want to enable locations and organizations.
  $locations_enabled     = false
  $organizations_enabled = false

  # Additional software repos
  $configure_epel_repo      = ($::osfamily == 'RedHat' and $::operatingsystem != 'Fedora')
  # Only configure extra SCL repos on EL
  $configure_scl_repo       = ($::osfamily == 'RedHat' and $::operatingsystem != 'Fedora')

  # Advanced configuration - no need to change anything here by default
  # if set to true, no repo will be added by this module, letting you
  # set it to some custom location.
  $custom_repo       = false
  # this can be a version or nightly
  $repo              = '1.18'
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

  # when undef, foreman-selinux will be installed if SELinux is enabled
  # setting to false/true will override this check (e.g. set to false on 1.1)
  $selinux     = undef

  # if enabled, will install and configure the database server on this host
  $db_manage   = true
  # Database 'production' settings
  $db_type     = 'postgresql'
  $db_username = 'foreman'
  # Generate and cache the password on the master once
  # In multi-puppetmaster setups, the user should specify their own
  $db_password = cache_data('foreman_cache_data', 'db_password', random_password(32))
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

  # Define job processing service properties
  $jobs_service = 'dynflowd'
  $jobs_service_ensure = 'running'
  $jobs_service_enable = true

  $hsts_enabled = true

  # OS specific paths
  case $::osfamily {
    'RedHat': {
      $init_config = '/etc/sysconfig/foreman'
      $init_config_tmpl = 'foreman.sysconfig'

      case $::operatingsystem {
        'fedora': {
          $passenger_ruby = undef
          $passenger_ruby_package = undef
          $plugin_prefix = 'rubygem-foreman_'
        }
        default: {
          # add passenger::install::scl as EL uses SCL on Foreman 1.2+
          $passenger_ruby = '/usr/bin/tfm-ruby'
          $passenger_ruby_package = 'tfm-rubygem-passenger-native'
          $plugin_prefix = 'tfm-rubygem-foreman_'
        }
      }
    }
    'Debian': {
      $passenger_ruby = '/usr/bin/foreman-ruby'
      $passenger_ruby_package = undef
      $plugin_prefix = 'ruby-foreman-'
      $init_config = '/etc/default/foreman'
      $init_config_tmpl = 'foreman.default'
    }
    'Linux': {
      case $::operatingsystem {
        'Amazon': {
          # add passenger::install::scl as EL uses SCL on Foreman 1.2+
          $passenger_ruby = '/usr/bin/tfm-ruby'
          $passenger_ruby_package = 'tfm-rubygem-passenger-native'
          $plugin_prefix = 'tfm-rubygem-foreman_'
          $init_config = '/etc/sysconfig/foreman'
          $init_config_tmpl = 'foreman.sysconfig'
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

  # We need the REST API interface with OAuth for some REST Puppet providers
  $oauth_active = true
  $oauth_map_users = false
  $oauth_consumer_key = cache_data('foreman_cache_data', 'oauth_consumer_key', random_password(32))
  $oauth_consumer_secret = cache_data('foreman_cache_data', 'oauth_consumer_secret', random_password(32))

  # Initial admin account details
  $admin_username = 'admin'
  $admin_password = cache_data('foreman_cache_data', 'admin_password', random_password(16))
  $admin_first_name = undef
  $admin_last_name = undef
  $admin_email = undef

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

  # Starting puppet runs with foreman
  $puppetrun = false

  # KeepAlive settings of Apache
  $keepalive              = true
  $max_keepalive_requests = 100
  $keepalive_timeout      = 5

  # Default ports for Apache to listen on
  $server_port     = 80
  $server_ssl_port = 443

}
