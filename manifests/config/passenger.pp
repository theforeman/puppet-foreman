# Configure the foreman service using passenger
class foreman::config::passenger (
  # specifiy which interface to bind passenger to eth0, eth1, ...
  $listen_on_interface = '',
  $scl_prefix = undef
) {

  # validate parameter values
  validate_string($listen_on_interface)

  include apache

  # Check the value in case the interface doesn't exist, otherwise listen on all interfaces
  if $listen_on_interface in split($::interfaces, ',') {
    $listen_interface = inline_template("<%= @ipaddress_${listen_on_interface} %>")
  } else {
    $listen_interface = undef
  }

  # Set up passenger
  if $scl_prefix {
    class {'apache::mod::passenger':
      passenger_ruby => "/usr/bin/${scl_prefix}-ruby",
      #package        => "${scl_prefix}-rubygem-passenger-native", # FIXME PR
    }
  } else {
    include apache::mod::passenger
  }

  if $foreman::use_vhost {
    apache::vhost { 'foreman':
      #ip              => $listen_interface, # FIXME
      port            => 80,
      docroot         => "${foreman::app_root}/public",
      priority        => '15',
      notify          => Service['httpd'],
      require         => Class['foreman::install'],
    }
  } else {
    file { 'foreman_vhost':
      path    => "${foreman::apache_conf_dir}/foreman.conf",
      content => template('foreman/foreman-apache.conf.erb'),
      mode    => '0644',
      notify  => Service['httpd'],
      require => Class['foreman::install'],
    }
  }

  if $foreman::ssl {
    if $foreman::use_vhost {
      apache::vhost { 'foreman-ssl':
        #ip              => $listen_interface, # FIXME
        port            => 80,
        docroot         => "${foreman::app_root}/public",
        priority        => '15',
        ssl             => true,
        ssl_cert        => "/var/lib/puppet/ssl/certs/${::fqdn}.pem",
        ssl_key         => "/var/lib/puppet/ssl/private_keys/${::fqdn}.pem",
        ssl_chain       => '/var/lib/puppet/ssl/certs/ca.pem',
        ssl_ca          => '/var/lib/puppet/ssl/certs/ca.pem',
        notify          => Service['httpd'],
        require         => Class['foreman::install'],
      }
    } else {
      include apache::mod::ssl

      file { 'foreman_vhost':
        path    => "${foreman::apache_conf_dir}/foreman-ssl.conf",
        content => template('foreman/foreman-apache.conf.erb'),
        mode    => '0644',
        notify  => Service['httpd'],
        require => Class['foreman::install'],
      }
    }
  }

  file { ["${foreman::app_root}/config.ru", "${foreman::app_root}/config/environment.rb"]:
    owner   => $foreman::user,
    require => Class['foreman::install'],
  }
}
