# This class includes the necessary scripts for Foreman on the puppetmaster and
# is intented to be added to your puppetmaster
class foreman::puppetmaster (
  $foreman_url      = $foreman::params::foreman_url,
  $foreman_user     = $foreman::params::foreman_user,
  $foreman_password = $foreman::params::foreman_password,
  $reports          = $foreman::params::reports,
  $enc              = $foreman::params::enc,
  $facts            = $foreman::params::facts,
  $puppet_home      = $foreman::params::puppet_home,
  $puppet_basedir   = $foreman::params::puppet_basedir,
  $ssl_ca           = $foreman::params::client_ssl_ca,
  $ssl_cert         = $foreman::params::client_ssl_cert,
  $ssl_key          = $foreman::params::client_ssl_key,
  $enc_api          = 'v2',
  $report_api       = 'v2'
) inherits foreman::params {

  case $::operatingsystem {
    'Debian','Ubuntu': {
      case $::lsbdistcodename {
        'squeeze': { $json_package = 'libjson-ruby' }
        default:   { $json_package = 'ruby-json' }
      }
    }
    default:       { $json_package = 'rubygem-json' }
  }

  package { $json_package:
    ensure  => installed,
  }

  file {'/etc/puppet/foreman.yaml':
    content => template("${module_name}/puppet.yaml.erb"),
    mode    => '0640',
    owner   => 'root',
    group   => 'puppet',
  }

  if $reports {   # foreman reporter

    exec { 'Create Puppet Reports dir':
      command => "/bin/mkdir -p ${puppet_basedir}/reports",
      creates => "${puppet_basedir}/reports"
    }
    file {"${puppet_basedir}/reports/foreman.rb":
      mode    => '0644',
      owner   => 'root',
      group   => 'root',
      source  => "puppet:///modules/${module_name}/foreman-report_${report_api}.rb",
      require => Exec['Create Puppet Reports dir'],
    }
  }

  if $enc {
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
      require                 => Class['::puppet::server::install'],
    }

    file { "${puppet_home}/yaml/foreman":
      ensure  => directory,
      owner   => 'puppet',
      group   => 'puppet',
      require => Class['::puppet::server::install'],
    }
  }
}
