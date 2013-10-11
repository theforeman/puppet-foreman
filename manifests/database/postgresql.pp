# Set up the foreman database using postgresql
class foreman::database::postgresql {
  $dbname = $foreman::db_database ? {
    'UNSET' => 'foreman',
    default => $foreman::db_database,
  }

  $password = $foreman::db_password ? {
    'UNSET' => false,
    default => postgresql_password($foreman::db_username, $foreman::db_password),
  }

  # Prevents errors if run from /root etc.
  Postgresql_psql {
    cwd => '/',
  }

  include postgresql::client, postgresql::server
  $grant = 'ALL'
  # TODO copied from puppetlabs-postgresql 2.3.0 manifests/db.pp
  # should be removed by db once they expose owner parameter
  postgresql::database { $dbname:
    charset     => $postgresql::params::charset,
    tablespace  => undef,
    require     => Class['postgresql::server'],
    locale      => $postgresql::params::locale,
    owner       => $dbname,
  }

  if ! defined(Postgresql::Database_user[$user]) {
    postgresql::database_user { $dbname:
      password_hash   => $password,
      require         => Postgresql::Database[$dbname],
    }
  }

  postgresql::database_grant { "GRANT ${$foreman::db_username} - ${grant} - ${dbname}":
    privilege       => $grant,
    db              => $dbname,
    role            => $foreman::db_username,
    require         => [Postgresql::Database[$dbname], Postgresql::Database_user[$foreman::db_username]],
  }
}
