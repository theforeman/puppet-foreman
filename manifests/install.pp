class foreman::install {
  if ! $foreman::custom_repo {
    foreman::install::repos { 'foreman':
      use_testing    => $foreman::use_testing,
      package_source => $foreman::package_source,
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
    $sqlite = $osfamily ? {
      RedHat => "foreman-sqlite",
      Debian => "foreman-sqlite3"
    }

    package {'foreman-sqlite3':
      name => $sqlite
      ensure  => latest,
      require => $repo,
      notify  => [Class['foreman::service'],Package['foreman']],
    }
  }

}
