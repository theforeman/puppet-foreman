# Install the needed packages for foreman
class foreman::install {
  if ! $foreman::custom_repo {
    foreman::install::repos { 'foreman':
      repo => $foreman::repo,
      gpgcheck => $foreman::gpgcheck,
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
      $package = 'foreman-mysql2'
    }
  }

  package { $package:
    ensure  => $foreman::version,
    require => $repo,
  }

  if $foreman::selinux or (str2bool($::selinux) and $foreman::selinux != false) {
    package { 'foreman-selinux':
      ensure  => $foreman::version,
      require => $repo,
    }
  }
}
