# = Foreman Remote Execution
# Installs foreman_remote_execution plugin
#
# === Parameters:
#
# $cockpit:: Install cockpit support
#
class foreman::plugin::remote_execution (
  Boolean $cockpit = $::foreman::plugin::remote_execution::params::cockpit,
) inherits foreman::plugin::remote_execution::params {
  include ::foreman::plugin::tasks

  foreman::plugin {'remote_execution':
  }

  if $cockpit {
    case $::osfamily {
      'RedHat': {
        case $::operatingsystem {
          'fedora': {
            $cockpit_package = 'rubygem-foreman_remote_execution-cockpit'
          }
          default: {
            $cockpit_package = 'tfm-rubygem-foreman_remote_execution-cockpit'
          }
        }
      }
      default: {
        fail("${::hostname}: foreman_remote_execution cockpit integration does not support osfamily ${::osfamily}")
      }
    }

    package { $cockpit_package:
      ensure => present,
    }
    ->
    service { 'foreman-cockpit':
      ensure     => running,
      enable     => true,
      hasstatus  => true,
      hasrestart => true,
    }

    file { '/etc/foreman/cockpit/cockpit.conf':
      ensure  => file,
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      content => template('foreman/remote_execution_cockpit.conf.erb'),
      notify  => Service['foreman-cockpit'],
    }

    file { '/etc/foreman/cockpit/foreman-cockpit-session.yml':
      ensure  => file,
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      content => template('foreman/remote_execution_cockpit_session.yml.erb'),
      notify  => Service['foreman-cockpit'],
    }

    foreman::config::apache::fragment { 'cockpit':
      ssl_content => template('foreman/cockpit-apache-ssl.conf.erb'),
    }

    foreman_config_entry { 'remote_execution_cockpit_url':
      value => "/webcon/=%{host}",
    }
  }
}
