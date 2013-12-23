# Configure the foreman ENC for a puppet server
class foreman::config::enc (
  $puppet_home = $foreman::params::puppet_home,
  $enc_api     = 'v2'
) inherits foreman::params {

  File { require => Class['::puppet::server::install'] }

  file { '/etc/puppet/node.rb':
    source => "puppet:///modules/${module_name}/external_node_${enc_api}.rb",
    mode   => '0550',
    owner  => 'puppet',
    group  => 'puppet',
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
