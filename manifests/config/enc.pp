# Configure the foreman ENC for a puppet server
class foreman::config::enc (
  $foreman_url  = $foreman::params::foreman_url,
  $facts        = $foreman::params::facts,
  $puppet_home  = $foreman::params::puppet_home,
  $ssl_ca       = $foreman::params::client_ssl_ca,
  $ssl_cert     = $foreman::params::client_ssl_cert,
  $ssl_key      = $foreman::params::client_ssl_key
) inherits foreman::params {

  File { require => Class['::puppet::server::install'] }

  file { '/etc/puppet/node.rb':
    content => template('foreman/external_node.rb.erb'),
    mode    => '0550',
    owner   => 'puppet',
    group   => 'puppet',
  }
  file { "${puppet_home}/yaml":
    ensure                  => directory,
    recurse                 => true,
    owner                   => 'puppet',
    group                   => 'puppet',
    selinux_ignore_defaults => true,
  }
  file { "${puppet_home}/yaml/foreman":
    ensure  => directory,
    owner   => 'puppet',
    group   => 'puppet',
  }
}
