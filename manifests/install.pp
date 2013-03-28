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

  case $foreman::db_type {
    sqlite: {
      case $::operatingsystem {
        Debian,Ubuntu: { $package = 'foreman-sqlite3' }
        default:       { $package = 'foreman-sqlite' }
      }
    }
    postgresql: {
      $package = 'foreman-postgresql'
    }
    mysql: {
      $package = 'foreman-mysql'
    }
  }

  package { $package:
    ensure  => present,
    require => $repo,
  }
}
