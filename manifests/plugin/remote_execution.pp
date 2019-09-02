# = Foreman Remote Execution
# Installs foreman_remote_execution plugin
#
# === Parameters:
#
# $cockpit:: Install cockpit support
#
class foreman::plugin::remote_execution (
  Boolean $cockpit = false,
) {
  include ::foreman::plugin::tasks
  include apache::mod::proxy_wstunnel
  include apache::mod::proxy_http

  foreman::plugin {'remote_execution':
  }

  $cockpit_subpath = 'webcon'

  if $cockpit {
    if $::osfamily != 'RedHat' {
      fail("${::hostname}: foreman_remote_execution cockpit integration does not support osfamily ${::osfamily}")
    }

    foreman::plugin { 'remote_execution-cockpit': }
    -> service { 'foreman-cockpit':
      ensure => running,
      enable => true,
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
      value => "/${cockpit_subpath}/=%{host}",
    }
  }
}
