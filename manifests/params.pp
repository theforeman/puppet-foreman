class foreman::params {

# Basic configurations
  $foreman_url  = "http://${::fqdn}"
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
  $authentication = false
  # configure foreman via apache and passenger
  $passenger    = true
  # force SSL (note: requires passenger)
  $ssl          = true

# Advance configurations - no need to change anything here by default
  # if set to true, no repo will be added by this module, letting you to
  # set it to some custom location.
  $custom_repo = false
  # allow usage of testing rpm/deb packages as well
  $use_testing = true
  $railspath   = '/usr/share'
  $app_root    = "${railspath}/foreman"
  $user        = 'foreman'
  $environment = 'production'
  $use_sqlite  = true

  # OS specific paths
  case $::operatingsystem {
    redhat,centos,fedora,Scientific: {
      $puppet_basedir  = '/usr/lib/ruby/site_ruby/1.8/puppet'
      $apache_conf_dir = '/etc/httpd/conf.d'
      $yumrepo = $operatingsystemrelease ? {
        16      => 'http://yum.theforeman.org/releases/1.0/f16/$basearch',
        17      => 'http://yum.theforeman.org/releases/1.0/f17/$basearch',
        /(5.*)/ => 'http://yum.theforeman.org/releases/1.0/el5/$basearch',
        /(6.*)/ => 'http://yum.theforeman.org/releases/1.0/el6/$basearch'
      }
    }
    Debian,Ubuntu: {
      $puppet_basedir  = '/usr/lib/ruby/1.8/puppet'
      $apache_conf_dir = '/etc/apache2/conf.d'
    }
    default:              {
      $puppet_basedir  = '/usr/lib/ruby/1.8/puppet'
      $apache_conf_dir = '/etc/apache2/conf.d/foreman.conf'
    }
  }
  $puppet_home = '/var/lib/puppet'
}
