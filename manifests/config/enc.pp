class foreman::config::enc (
  $foreman_url  = $foreman::params::foreman_url,
  $facts        = $foreman::params::facts,
  $storeconfigs = $foreman::params::storeconfigs,
  $puppet_home  = $foreman::params::puppet_home
) inherits foreman::params {

  File { require => Class['::puppet::server::install'] }

  file { '/etc/puppet/node.rb':
    content => template('foreman/external_node.rb.erb'),
    mode    => '0550',
    owner   => 'puppet',
    group   => 'puppet',
  }
  file { "${puppet_home}/yaml":
    ensure  => directory,
    recurse => true,
    mode    => '0640',
    owner   => 'puppet',
    group   => 'puppet',
  }
  file { "${puppet_home}/yaml/foreman":
    ensure  => directory,
    mode    => '0640',
    owner   => 'puppet',
    group   => 'puppet',
  }
}
