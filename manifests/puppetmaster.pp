# @summary Set up Foreman integration for a Puppetserver
#
# This class includes the necessary scripts for Foreman on the puppetmaster and
# is intented to be added to your puppetmaster
#
# @param foreman_url
#   The Foreman URL
# @param enc
#   Whether to install the ENC script
# @param receive_facts
#   Whether to configure the ENC to send facts to Foreman
# @param puppet_home
#   The Puppet home where the YAML files with facts live. Used for the ENC script
# @param reports
#   Whether to enable the report processor
# @param puppet_user
#   The user used to run the Puppetserver
# @param puppet_group
#   The group used to run the Puppetserver
# @param puppet_basedir
#   The directory used to install the report processor to
# @param puppet_etcdir
#   The directory used to put the configuration in.
# @param timeout
#   The timeout to use on HTTP calls in the ENC script
# @param report_timeout
#   The timeout to use on HTTP calls in the report processor
# @param ssl_ca
#   The SSL CA file path to use
# @param ssl_cert
#   The SSL certificate file path to use
# @param ssl_key
#   The SSL key file path to use
class foreman::puppetmaster (
  Stdlib::HTTPUrl $foreman_url = $::foreman::puppetmaster::params::foreman_url,
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
  Variant[Enum[''], Stdlib::Absolutepath] $ssl_ca = $::foreman::puppetmaster::params::client_ssl_ca,
  Variant[Enum[''], Stdlib::Absolutepath] $ssl_cert = $::foreman::puppetmaster::params::client_ssl_cert,
  Variant[Enum[''], Stdlib::Absolutepath] $ssl_key = $::foreman::puppetmaster::params::client_ssl_key,
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
      source  => "puppet:///modules/${module_name}/foreman-report_v2.rb",
      require => Exec['Create Puppet Reports dir'],
    }
  }

  if $enc {
    file { "${puppet_etcdir}/node.rb":
      source => "puppet:///modules/${module_name}/external_node_v2.rb",
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
