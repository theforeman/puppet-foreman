class foreman::install {
  if ! $foreman::custom_repo {
    class { '::foreman::install::repos': use_testing => $foreman::use_testing }
  }

  $repo = $foreman::custom_repo ? {
    true    => [],
    default => Class['foreman::install::repos'],
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
