class foreman::install {
  if ! $foreman::custom_repo {
    foreman::install::repos { 'foreman':
      repo => $foreman::repo
    }
  }

  $repo = $foreman::custom_repo ? {
    true    => [],
    default => Foreman::Install::Repos['foreman'],
  }

  package {'foreman':
    ensure  => present,
    require => $repo,
    notify  => Class['foreman::service'],
  }

  if $foreman::use_sqlite {
    case $::operatingsystem {
      Debian,Ubuntu: { $sqlite = 'foreman-sqlite3' }
      default:       { $sqlite = 'foreman-sqlite' }
    }

    package {'foreman-sqlite3':
      ensure  => present,
      name    => $sqlite,
      require => $repo,
      notify  => [Class['foreman::service'], Package['foreman']],
    }
  }

}
