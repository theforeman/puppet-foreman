class foreman::install {
  if ! $foreman::custom_repo {
    class { '::foreman::install::repos': use_testing => $foreman::use_testing }
  }
  case $::operatingsystem {
    Debian,Ubuntu:  {
      package {'foreman-sqlite3':
        ensure  => latest,
        require => $foreman::custom_repo ? { true => [], default => Class['foreman::install::repos'] },
        notify  => [Class['foreman::service'],
                    Package['foreman']],
      }
    }
    default: {}
  }

  package {'foreman':
    ensure  => present,
    require => $foreman::custom_repo ? { true => [], default => Class['foreman::install::repos'] },
    notify  => Class['foreman::service'],
  }

}
