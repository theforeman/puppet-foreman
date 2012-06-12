class foreman::install {
  class { '::foreman::install::repos': use_testing => $foreman::use_testing }
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

}
