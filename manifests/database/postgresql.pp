# Set up the foreman database using postgresql
class foreman::database::postgresql {
  # Prevents errors if run from /root etc.
  Postgresql_psql {
    cwd => '/',
  }

  include postgresql::client, postgresql::server

  postgresql::server::db { $foreman::db_database:
    user     => $foreman::db_username,
    password => postgresql::postgresql_password($foreman::db_username, $foreman::db_password),
    owner    => $foreman::db_username,
    encoding => 'utf8',
    locale   => 'en_US.utf8',
  }
}
