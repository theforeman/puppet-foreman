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

  if $foreman::package_source == 'nightly' {
    # Database is fine in nightly
  } else {
    #Configure the Debian database with some defaults
    case $::operatingsystem {
      Debian,Ubuntu: {
        file {'/etc/foreman/database.yml':
          content => template('foreman/database.yaml.erb'),
          notify  => Class['foreman::service'],
          owner   => $foreman::user,
          require => [User[$foreman::user],
          Package['foreman-sqlite3']],
        }
      }
      default: { }
    }
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
  # if you are using fact or report importers, this creates a session per request
  # which can easily result with a lot of old and unrequired in your database
  # eventually slowing it down.
  cron{'clear_session_table':
    command => "(cd ${foreman::app_root} && rake db:sessions:clear)",
    minute  => '15',
    hour    => '23',
  }

  if $foreman::reports { include foreman::config::reports }
  if $foreman::passenger  { include foreman::config::passenger }
}
