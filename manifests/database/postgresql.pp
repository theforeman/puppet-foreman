class foreman::database::postgresql {
  $dbname = $foreman::db_database ? {
    'UNSET' => 'foreman',
    default => $foreman::db_database,
  }

  # Prevents errors if run from /root etc.
  Postgresql_psql {
    cwd => "/",
  }

  include postgresql::client, postgresql::server
  postgresql::db { $dbname:
    user     => $foreman::db_username,
    password => postgresql_password($foreman::db_username, $foreman::db_password),
  }
}
