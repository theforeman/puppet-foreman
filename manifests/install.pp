class foreman::install {
  include foreman::install::repos

  case $::operatingsystem {
    Debian,Ubuntu:  {
      package {'foreman-sqlite3':
        ensure  => latest,
        require => Class['foreman::install::repos'],
        notify  => [Class['foreman::service'],
                    Package['foreman']],
      }
    }
    default: {}
  }

  package {'foreman':
    ensure  => present,
    require => Class['foreman::install::repos'],
    notify  => Class['foreman::service'],
  }

  package{[ "mysql-devel", "gcc", "ruby-devel" ]:
    ensure => present,
  }

  package{"mysql":
    provider => gem,
    require => [ Package["mysql-devel"], Package["gcc"], Package["ruby-devel"] ],
  }
}
