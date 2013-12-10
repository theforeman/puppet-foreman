# The foreman default parameters
class foreman::params {

# Basic configurations
  $foreman_url  = "https://${::fqdn}"
  # Should foreman act as an external node classifier (manage puppet class
  # assignments)
  $enc          = true
  # Should foreman receive reports from puppet
  $reports      = true
  # Should foreman recive facts from puppet
  $facts        = true
  # should foreman manage host provisioning as well
  $unattended   = true
  # Enable users authentication (default user:admin pw:changeme)
  $authentication = true
  # configure foreman via apache and passenger
  $passenger    = true
  # Enclose apache configuration in <VirtualHost>...</VirtualHost>
  $use_vhost    = true
  # force SSL (note: requires passenger)
  $ssl          = true
  #define which interface passenger should listen on, undef means all interfaces
  $passenger_interface = ''
  # Choose whether you want to enable locations and organizations.
  $locations_enabled      = false
  $organizations_enabled  = false

# Advance configurations - no need to change anything here by default
  # if set to true, no repo will be added by this module, letting you to
  # set it to some custom location.
  $custom_repo = false
  # this can be stable, rc, or nightly
  $repo        = 'stable'
  $railspath   = '/usr/share'
  $app_root    = "${railspath}/foreman"
  $user        = 'foreman'
  $group       = 'foreman'
  $user_groups = ['puppet']
  $environment = 'production'
  $gpgcheck    = true
  $version     = 'present'

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

  # OS specific paths
  case $::osfamily {
    RedHat: {
      $apache_conf_dir = '/etc/httpd/conf.d'

      case $::operatingsystem {
        fedora: {
          $puppet_basedir  = '/usr/share/ruby/vendor_ruby/puppet'
          $yumcode = "f${::operatingsystemrelease}"
          $passenger_scl = undef
        }
        default: {
          $puppet_basedir = regsubst($::rubyversion, '^(\d+\.\d+).*$', '/usr/lib/ruby/site_ruby/\1/puppet')
          $yumcode = regsubst($::operatingsystemrelease, '^(\d+)\..*$', 'el\1')
          # add passenger::install::scl as EL uses SCL on Foreman 1.2+
          $passenger_scl = 'ruby193'
        }
      }
    }
    Debian: {
      $puppet_basedir  = '/usr/lib/ruby/vendor_ruby/puppet'
      $apache_conf_dir = '/etc/apache2/conf.d'
      $passenger_scl = undef
    }
    Linux: {
      case $::operatingsystem {
        Amazon: {
          $apache_conf_dir = '/etc/httpd/conf.d'
          $puppet_basedir = regsubst($::rubyversion, '^(\d+\.\d+).*$', '/usr/lib/ruby/site_ruby/\1/puppet')
          $yumcode = 'el6'
          # add passenger::install::scl as EL uses SCL on Foreman 1.2+
          $passenger_scl = 'ruby193'
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
  $puppet_home = '/var/lib/puppet'
  $puppet_user = 'puppet'

  # If CA is specified, remote Foreman host will be verified in reports/ENC scripts
  $client_ssl_ca   = "${puppet_home}/ssl/certs/ca.pem"
  # Used to authenticate to Foreman, required if require_ssl_puppetmasters is enabled
  $client_ssl_cert = "${puppet_home}/ssl/certs/${::fqdn}.pem"
  $client_ssl_key  = "${puppet_home}/ssl/private_keys/${::fqdn}.pem"

  # Set these values if you want Passenger to serve a CA-provided cert instead of puppet's
  $server_ssl_ca   = "${puppet_home}/ssl/certs/ca.pem"
  $server_ssl_cert = "${puppet_home}/ssl/certs/${::fqdn}.pem"
  $server_ssl_key  = "${puppet_home}/ssl/private_keys/${::fqdn}.pem"

  # We need the REST API interface with OAuth for some REST Puppet providers
  $oauth_active = true
  $oauth_map_users = true
  $oauth_consumer_key = cache_data('oauth_consumer_key', random_password(32))
  $oauth_consumer_secret = cache_data('oauth_consumer_secret', random_password(32))
}
