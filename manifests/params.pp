# The foreman default parameters
class foreman::params {

# Basic configurations
  $foreman_url      = "https://${::fqdn}"
  $foreman_user     = undef
  $foreman_password = undef
  # Should foreman act as an external node classifier (manage puppet class
  # assignments)
  $enc          = true
  # Should foreman receive reports from puppet
  $reports      = true
  # Should foreman receive facts from puppet
  $receive_facts = true
  # should foreman manage host provisioning as well
  $unattended   = true
  # Enable users authentication (default user:admin pw:changeme)
  $authentication = true
  # configure foreman via apache and passenger
  $passenger    = true
  # Enclose apache configuration in <VirtualHost>...</VirtualHost>
  $use_vhost    = true
  # Server name of the VirtualHost
  $servername   = $::fqdn
  # force SSL (note: requires passenger)
  $ssl          = true
  #define which interface passenger should listen on, undef means all interfaces
  $passenger_interface = undef
  # Choose whether you want to enable locations and organizations.
  $locations_enabled     = false
  $organizations_enabled = false

  # Additional software repos
  $configure_epel_repo      = ($::osfamily == 'RedHat' and $::operatingsystem != 'Fedora')
  # Only configure extra SCL repos on EL clones, RHEL itself usually has RHSCL
  $configure_scl_repo       = ($::osfamily == 'RedHat' and $::operatingsystem != 'RedHat' and $::operatingsystem != 'Fedora')
  # Only configure Brightbox PPA on Ubuntu 12.04 (precise)
  $configure_brightbox_repo = ($::operatingsystem == 'Ubuntu' and $::operatingsystemrelease == '12.04')

# Advanced configuration - no need to change anything here by default
  # if set to true, no repo will be added by this module, letting you to
  # set it to some custom location.
  $custom_repo       = false
  # this can be stable, or nightly
  $repo              = 'stable'
  $railspath         = '/usr/share'
  $app_root          = "${railspath}/foreman"
  $plugin_config_dir = '/etc/foreman/plugins'
  $manage_user       = true
  $user              = 'foreman'
  $group             = 'foreman'
  $user_groups       = ['puppet']
  $environment       = 'production'
  $gpgcheck          = true
  $version           = 'present'

  $puppetmaster_timeout = 60

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
  $db_password = cache_data('db_password', random_password(32))
  # Default database connection pool
  $db_pool = 5

  # Apipie doc generation method (1.8+ should use index only)
  $apipie_task = 'apipie:cache:index'

  # OS specific paths
  case $::osfamily {
    'RedHat': {
      $init_config = '/etc/sysconfig/foreman'
      $init_config_tmpl = 'foreman.sysconfig'

      case $::operatingsystem {
        'fedora': {
          $puppet_basedir  = '/usr/share/ruby/vendor_ruby/puppet'
          $yumcode = "f${::operatingsystemrelease}"
          $passenger_ruby = undef
          $passenger_ruby_package = undef
          $plugin_prefix = 'rubygem-foreman_'
          case $::operatingsystemrelease {
            '19': {
              $passenger_prestart = false
              $passenger_min_instances = 1
              $passenger_start_timeout = undef
            }
            default: {
              $passenger_prestart = true
              $passenger_min_instances = 1
              $passenger_start_timeout = 600
            }
          }
        }
        default: {
          $osreleasemajor = regsubst($::operatingsystemrelease, '^(\d+)\..*$', '\1')
          $yumcode = "el${osreleasemajor}"
          $puppet_basedir = $osreleasemajor ? {
            '6'     => regsubst($::rubyversion, '^(\d+\.\d+).*$', '/usr/lib/ruby/site_ruby/\1/puppet'),
            default => '/usr/share/ruby/vendor_ruby/puppet',
          }
          # add passenger::install::scl as EL uses SCL on Foreman 1.2+
          $passenger_ruby = '/usr/bin/ruby193-ruby'
          $passenger_ruby_package = 'ruby193-rubygem-passenger-native'
          $plugin_prefix = 'ruby193-rubygem-foreman_'
          $passenger_prestart = true
          $passenger_min_instances = 1
          $passenger_start_timeout = 600
        }
      }
    }
    'Debian': {
      $puppet_basedir  = '/usr/lib/ruby/vendor_ruby/puppet'
      $passenger_ruby = $::operatingsystemrelease ? {
        '12.04' => '/usr/bin/ruby1.9.1',
        default => undef,
      }
      $passenger_ruby_package = $::operatingsystemrelease ? {
        '12.04' => 'passenger-common1.9.1',
        default => undef,
      }
      $plugin_prefix = 'ruby-foreman-'
      $init_config = '/etc/default/foreman'
      $init_config_tmpl = 'foreman.default'

      $osreleasemajor = regsubst($::operatingsystemrelease, '^(\d+)\..*$', '\1')

      case $osreleasemajor {
        '12': {
          # 12 is Ubuntu/precise here, once precise support is dropped,
          # this should be dropped to not collide with Debian 12
          $passenger_prestart = false
          $passenger_min_instances = undef
          $passenger_start_timeout = undef
        }
        '7': {
          $passenger_prestart = false
          $passenger_min_instances = 1
          $passenger_start_timeout = undef
        }
        default: {
          $passenger_prestart = true
          $passenger_min_instances = 1
          $passenger_start_timeout = 600
        }
      }
    }
    'Linux': {
      case $::operatingsystem {
        'Amazon': {
          $puppet_basedir = regsubst($::rubyversion, '^(\d+\.\d+).*$', '/usr/lib/ruby/site_ruby/\1/puppet')
          $yumcode = 'el6'
          # add passenger::install::scl as EL uses SCL on Foreman 1.2+
          $passenger_ruby = '/usr/bin/ruby193-ruby'
          $passenger_ruby_package = 'ruby193-rubygem-passenger-native'
          $plugin_prefix = 'ruby193-rubygem-foreman_'
          $init_config = '/etc/sysconfig/foreman'
          $init_config_tmpl = 'foreman.sysconfig'
          $passenger_prestart = true
          $passenger_min_instances = 1
          $passenger_start_timeout = 600
        }
        default: {
          fail("${::hostname}: This module does not support operatingsystem ${::operatingsystem}")
        }
      }
    }
    /(ArchLinux|Suse)/: {
      # Only the agent classes (cron / service) are supported for now, which
      # doesn't require any OS-specific params
    }
    'windows': {
      $puppet_basedir = undef
      $yumcode = undef
      $passenger_ruby = undef
      $passenger_ruby_package = undef
      $plugin_prefix = undef
    }
    default: {
      fail("${::hostname}: This module does not support osfamily ${::osfamily}")
    }
  }
  $puppet_home = '/var/lib/puppet'
  $puppet_user = 'puppet'
  $puppet_group = 'puppet'
  $lower_fqdn = downcase($::fqdn)

  # If CA is specified, remote Foreman host will be verified in reports/ENC scripts
  $client_ssl_ca   = "${puppet_home}/ssl/certs/ca.pem"
  # Used to authenticate to Foreman, required if require_ssl_puppetmasters is enabled
  $client_ssl_cert = "${puppet_home}/ssl/certs/${lower_fqdn}.pem"
  $client_ssl_key  = "${puppet_home}/ssl/private_keys/${lower_fqdn}.pem"

  # Set these values if you want Passenger to serve a CA-provided cert instead of puppet's
  $server_ssl_ca    = "${puppet_home}/ssl/certs/ca.pem"
  $server_ssl_chain = "${puppet_home}/ssl/certs/ca.pem"
  $server_ssl_cert  = "${puppet_home}/ssl/certs/${lower_fqdn}.pem"
  $server_ssl_key   = "${puppet_home}/ssl/private_keys/${lower_fqdn}.pem"
  $server_ssl_crl   = "${puppet_home}/ssl/ca/ca_crl.pem"

  # We need the REST API interface with OAuth for some REST Puppet providers
  $oauth_active = true
  $oauth_map_users = false
  $oauth_consumer_key = cache_data('oauth_consumer_key', random_password(32))
  $oauth_consumer_secret = cache_data('oauth_consumer_secret', random_password(32))

  # Initial admin account details
  $admin_username = 'admin'
  $admin_password = cache_data('admin_password', random_password(16))
  $admin_first_name = undef
  $admin_last_name = undef
  $admin_email = undef

  # Initial taxonomies
  $initial_organization = undef
  $initial_location = undef

  $ipa_authentication = false
  $http_keytab = '/etc/httpd/conf/http.keytab'
  $pam_service = 'foreman'
  $configure_ipa_repo = false
  $ipa_manage_sssd = true

  # Websockets
  $websockets_encrypt = true
  $websockets_ssl_key = $server_ssl_key
  $websockets_ssl_cert = $server_ssl_cert
}
