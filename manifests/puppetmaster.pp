# This class includes the necessary scripts for Foreman on the puppetmaster and
# is intented to be added to your puppetmaster
class foreman::puppetmaster (
  Stdlib::HTTPUrl $foreman_url = $::foreman::puppetmaster::params::foreman_url,
  Optional[String] $foreman_user = $::foreman::puppetmaster::params::foreman_user,
  Optional[String] $foreman_password = $::foreman::puppetmaster::params::foreman_password,
  Boolean $reports = $::foreman::puppetmaster::params::reports,
  Boolean $enc = $::foreman::puppetmaster::params::enc,
  Boolean $receive_facts = $::foreman::puppetmaster::params::receive_facts,
  Stdlib::Absolutepath $puppet_home = $::foreman::puppetmaster::params::puppet_home,
  String $puppet_user = $::foreman::puppetmaster::params::puppet_user,
  String $puppet_group = $::foreman::puppetmaster::params::puppet_group,
  Stdlib::Absolutepath $puppet_basedir = $::foreman::puppetmaster::params::puppet_basedir,
  Stdlib::Absolutepath $puppet_etcdir = $::foreman::puppetmaster::params::puppet_etcdir,
  Integer $timeout = $::foreman::puppetmaster::params::puppetmaster_timeout,
  Integer $report_timeout = $::foreman::puppetmaster::params::puppetmaster_report_timeout,
  Stdlib::Absolutepath $ssl_ca = $::foreman::puppetmaster::params::client_ssl_ca,
  Stdlib::Absolutepath $ssl_cert = $::foreman::puppetmaster::params::client_ssl_cert,
  Stdlib::Absolutepath $ssl_key = $::foreman::puppetmaster::params::client_ssl_key,
  Enum['v2'] $enc_api = 'v2',
  Enum['v2'] $report_api = 'v2',
) inherits foreman::puppetmaster::params {

  case $::osfamily {
    'Debian': { $json_package = 'ruby-json' }
    default:  { $json_package = 'rubygem-json' }
  }

  ensure_packages([$json_package])

  file {"${puppet_etcdir}/foreman.yaml":
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
      group   => '0',
      source  => "puppet:///modules/${module_name}/foreman-report_${report_api}.rb",
      require => Exec['Create Puppet Reports dir'],
    }
  }

  if $enc {
    file { "${puppet_etcdir}/node.rb":
      source => "puppet:///modules/${module_name}/external_node_${enc_api}.rb",
      mode   => '0550',
      owner  => $puppet_user,
      group  => $puppet_group,
    }

    file { "${puppet_home}/yaml":
      ensure                  => directory,
      owner                   => $puppet_user,
      group                   => $puppet_group,
      mode                    => '0750',
      selinux_ignore_defaults => true,
    }

    file { "${puppet_home}/yaml/foreman":
      ensure => directory,
      owner  => $puppet_user,
      group  => $puppet_group,
      mode   => '0750',
    }

    file { "${puppet_home}/yaml/node":
      ensure => directory,
      owner  => $puppet_user,
      group  => $puppet_group,
      mode   => '0750',
    }

    file { "${puppet_home}/yaml/facts":
      ensure => directory,
      owner  => $puppet_user,
      group  => $puppet_group,
      mode   => '0750',
    }
  }
}
