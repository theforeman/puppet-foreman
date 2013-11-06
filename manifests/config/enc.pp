# Configure the foreman ENC for a puppet server
class foreman::config::enc (
  $foreman_url = $foreman::params::foreman_url,
  $facts       = $foreman::params::facts,
  $puppet_home = $foreman::params::puppet_home,
  $puppet_user = $foreman::params::puppet_user,
  $ssl_ca      = $foreman::params::client_ssl_ca,
  $ssl_cert    = $foreman::params::client_ssl_cert,
  $ssl_key     = $foreman::params::client_ssl_key,
  $enc_api     = 'v2'
) inherits foreman::params {

  File { require => Class['::puppet::server::install'] }

  file { '/etc/puppet/node.rb':
    content => template("foreman/external_node_${enc_api}.rb.erb"),
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
