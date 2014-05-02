# Configure foreman
class foreman::config {
  concat_build {'foreman_settings':
    order => ['*.yaml'],
  }

  concat_fragment {'foreman_settings+01-header.yaml':
    content => template('foreman/settings.yaml.erb'),
  }

  file {'/etc/foreman/settings.yaml':
    source  => concat_output('foreman_settings'),
    require => Concat_build['foreman_settings'],
    owner   => 'root',
    group   => $foreman::group,
    mode    => '0640',
  }

  file { '/etc/foreman/database.yml':
    owner   => 'root',
    group   => $foreman::group,
    mode    => '0640',
    content => template('foreman/database.yml.erb'),
  }

  file { $foreman::init_config:
    ensure  => present,
    content => template("foreman/${foreman::init_config_tmpl}.erb"),
  }

  file { $foreman::app_root:
    ensure  => directory,
  }

  user { $foreman::user:
    ensure  => 'present',
    shell   => '/bin/false',
    comment => 'Foreman',
    home    => $foreman::app_root,
    gid     => $foreman::group,
    groups  => $foreman::user_groups,
  }

  # remove crons previously installed here, they've moved to the package's
  # cron.d file
  cron { ['clear_session_table', 'expire_old_reports', 'daily summary']:
    ensure  => absent,
  }

  if $foreman::passenger  {
    class { '::foreman::config::passenger': } -> anchor { 'foreman::config_end': }
  }
}
