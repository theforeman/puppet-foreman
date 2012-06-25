class foreman::install {
  if ! $foreman::custom_repo {
    foreman::install::repos { 'foreman': use_testing => $foreman::use_testing }
  }

  $repo = $foreman::custom_repo ? {
    true    => [],
    default => Foreman::Install::Repos['foreman'],
  }

  case $::operatingsystem {
    Debian,Ubuntu:  {
      package {'foreman-sqlite3':
        ensure  => latest,
        require => $repo,
        notify  => [Class['foreman::service'],
                    Package['foreman']],
      }
    }
    default: {}
  }

  package {'foreman':
    ensure  => present,
    require => $repo,
    notify  => Class['foreman::service'],
  }

}
