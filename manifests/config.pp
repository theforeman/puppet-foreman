class foreman::config {
  Cron {
    require     => User[$foreman::params::user],
    user        => $foreman::params::user,
    environment => "RAILS_ENV=${foreman::params::environment}",
  }

  file {'/etc/foreman/settings.yaml':
    content => template('foreman/settings.yaml.erb'),
    notify  => Class['foreman::service'],
    owner   => $foreman::params::user,
    require => User[$foreman::params::user],
  }

  #Configure the Debian database with some defaults
  case $::operatingsystem {
    Debian,Ubuntu: {
      file {'/etc/foreman/database.yml':
        content => template('foreman/database.yaml.erb'),
        notify  => Class['foreman::service'],
        owner   => $foreman::params::user,
        require => [User[$foreman::params::user],
                    Package['foreman-sqlite3']],
      }
    }
    default: { }
  }

  file { $foreman::params::app_root:
    ensure  => directory,
  }

  user { $foreman::params::user:
    ensure  => 'present',
    shell   => '/sbin/nologin',
    comment => 'Foreman',
    home    => $foreman::params::app_root,
    require => Class['foreman::install'],
  }

  # cleans up the session entries in the database
  # if you are using fact or report importers, this creates a session per request
  # which can easily result with a lot of old and unrequired in your database
  # eventually slowing it down.
  cron{'clear_session_table':
    command => "(cd ${foreman::params::app_root} && rake db:sessions:clear)",
    minute  => '15',
    hour    => '23',
  }

  if $foreman::params::reports { include foreman::config::reports }
  if $foreman::params::enc     { include foreman::config::enc }
  if $foreman::params::passenger  { include foreman::config::passenger }
}
