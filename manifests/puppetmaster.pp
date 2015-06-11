# This class includes the necessary scripts for Foreman on the puppetmaster and
# is intented to be added to your puppetmaster
class foreman::puppetmaster (
  $foreman_url      = $foreman::foreman_url,
  $foreman_user     = $foreman::foreman_user,
  $foreman_password = $foreman::foreman_password,
  $reports          = $foreman::reports,
  $enc              = $foreman::enc,
  $receive_facts    = $foreman::receive_facts,
  $puppet_home      = $foreman::puppet_home,
  $puppet_user      = $foreman::puppet_user,
  $puppet_group     = $foreman::puppet_group,
  $puppet_basedir   = $foreman::puppet_basedir,
  $timeout          = $foreman::puppetmaster_timeout,
  $ssl_ca           = $foreman::client_ssl_ca,
  $ssl_cert         = $foreman::client_ssl_cert,
  $ssl_key          = $foreman::client_ssl_key,
  $enc_api          = 'v2',
  $report_api       = 'v2',
) inherits foreman::params {

  case $::osfamily {
    'Debian': { $json_package = 'ruby-json' }
    default:  { $json_package = 'rubygem-json' }
  }

  package { $json_package:
    ensure  => installed,
  }

  file {'/etc/puppet/foreman.yaml':
    content => template("${module_name}/puppet.yaml.erb"),
    mode    => '0640',
    owner   => 'root',
    group   => $puppet_group,
  }

  if $reports {   # foreman reporter

    exec { 'Create Puppet Reports dir':
      command => "/bin/mkdir -p ${puppet_basedir}/reports",
      creates => "${puppet_basedir}/reports",
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
      owner  => $puppet_user,
      group  => $puppet_group,
    }

    file { "${puppet_home}/yaml":
      ensure                  => directory,
      owner                   => $puppet_user,
      group                   => $puppet_group,
      selinux_ignore_defaults => true,
    }

    file { "${puppet_home}/yaml/foreman":
      ensure => directory,
      owner  => $puppet_user,
      group  => $puppet_group,
    }
  }
}
