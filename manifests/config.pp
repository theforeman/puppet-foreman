class foreman::config {
  Cron {
    require     => User[$foreman::user],
    user        => $foreman::user,
    environment => "RAILS_ENV=${foreman::environment}",
  }

  file {'/etc/foreman/settings.yaml':
    content => template('foreman/settings.yaml.erb'),
    notify  => Class['foreman::service'],
    owner   => $foreman::user,
    require => User[$foreman::user],
  }

  case $::operatingsystem {
    Debian,Ubuntu: {
      $init_config = "/etc/default/foreman"
      $init_config_tmpl = "foreman.default"
    }
    default: {
      $init_config = "/etc/sysconfig/foreman"
      $init_config_tmpl = "foreman.sysconfig"
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

  # cleans up the session entries in the database
  # if you are using fact or report importers, this creates a session per
  # request which can easily result with a lot of old and unrequired in your
  # database eventually slowing it down.
  cron{'clear_session_table':
    command => "(cd ${foreman::app_root} && rake db:sessions:clear)",
    minute  => '15',
    hour    => '23',
  }

  if $foreman::reports { include foreman::config::reports }
  if $foreman::passenger  { include foreman::config::passenger }
}
