# Configure foreman
class foreman::config {
  Cron {
    require     => User[$foreman::user],
    user        => $foreman::user,
    environment => "RAILS_ENV=${foreman::environment}",
  }

  concat_build {'foreman_settings':
    order => ['*.yaml'],
  }

  concat_fragment {'foreman_settings+01-header.yaml':
    content => template('foreman/settings.yaml.erb'),
  }

  file {'/etc/foreman/settings.yaml':
    source  => concat_output('foreman_settings'),
    require => Concat_build['foreman_settings'],
    notify  => Class['foreman::service'],
    owner   => 'root',
    group   => $foreman::group,
    mode    => '0640',
  }

  file { '/etc/foreman/database.yml':
    owner   => 'root',
    group   => $foreman::group,
    mode    => '0640',
    content => template('foreman/database.yml.erb'),
    notify  => Class['foreman::service'],
  }

  case $::operatingsystem {
    Debian,Ubuntu: {
      $init_config = '/etc/default/foreman'
      $init_config_tmpl = 'foreman.default'
    }
    default: {
      $init_config = '/etc/sysconfig/foreman'
      $init_config_tmpl = 'foreman.sysconfig'
    }
  }
  file { $init_config:
    ensure  => present,
    content => template("foreman/${init_config_tmpl}.erb"),
    require => Class['foreman::install'],
    before  => Class['foreman::service'],
  }

  file { $foreman::app_root:
    ensure  => directory,
  }

  user { $foreman::user:
    ensure  => 'present',
    shell   => '/sbin/nologin',
    comment => 'Foreman',
    home    => $foreman::app_root,
    require => Class['foreman::install'],
  }

  # remove crons previously installed here, they've moved to the package's
  # cron.d file
  cron { ['clear_session_table', 'expire_old_reports', 'daily summary']:
    ensure  => absent,
  }

  if $foreman::passenger  {
    class{'foreman::config::passenger':
      listen_on_interface => $foreman::passenger_interface,
      scl_prefix          => $foreman::passenger_scl,
    }
  }

}
