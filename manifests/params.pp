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
  # Do you use storeconfig (and run foreman on the same database) ? (note: not
  # required)
  $storeconfigs = false
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
  $environment = 'production'
  $use_sqlite  = true

  # OS specific paths
  $ruby_major = regsubst($::rubyversion, '^(\d+\.\d+).*', '\1')
  case $::operatingsystem {
    fedora: {
      if $::operatingsystemrelease >= 17 {
        $puppet_basedir  = "/usr/share/ruby/vendor_ruby/puppet"
      } else {
        $puppet_basedir  = "/usr/lib/ruby/site_ruby/${ruby_major}/puppet"
      }
      $apache_conf_dir = '/etc/httpd/conf.d'
      $yumcode = "f${::operatingsystemrelease}"
    }
    redhat,centos,Scientific: {
      $puppet_basedir  = "/usr/lib/ruby/site_ruby/${ruby_major}/puppet"
      $apache_conf_dir = '/etc/httpd/conf.d'
      $osmajor = regsubst($::operatingsystemrelease, '\..*', '')
      $yumcode = "el${osmajor}"
    }
    Debian,Ubuntu: {
      $puppet_basedir  = '/usr/lib/ruby/vendor_ruby/puppet'
      $apache_conf_dir = '/etc/apache2/conf.d'
    }
    default:              {
      $puppet_basedir  = "/usr/lib/ruby/${ruby_major}/puppet"
      $apache_conf_dir = '/etc/apache2/conf.d/foreman.conf'
    }
  }
  $puppet_home = '/var/lib/puppet'

  # If CA is specified, remote Foreman host will be verified in reports/ENC scripts
  $client_ssl_ca   = "${puppet_home}/ssl/certs/ca.pem"
  # Used to authenticate to Foreman, required if require_ssl_puppetmasters is enabled
  $client_ssl_cert = "${puppet_home}/ssl/certs/${fqdn}.pem"
  $client_ssl_key  = "${puppet_home}/ssl/private_keys/${fqdn}.pem"
}
