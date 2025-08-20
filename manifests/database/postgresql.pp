# Set up the foreman database using postgresql
class foreman::database::postgresql {
  # Prevents errors if run from /root etc.
  Postgresql_psql {
    cwd => '/',
  }

  include postgresql::client, postgresql::server, postgresql::server::contrib
  include foreman::database::postgresql::encoding

  postgresql::server::db { $foreman::db_database:
    user     => $foreman::db_username,
    password => postgresql::postgresql_password($foreman::db_username, $foreman::db_password),
    owner    => $foreman::db_username,
    encoding => 'utf8',
    locale   => 'en_US.utf8',
    require  => Class['foreman::database::postgresql::encoding'],
  }

  postgresql::server::extension { "amcheck for ${foreman::db_database}":
    database  => $foreman::db_database,
    extension => 'amcheck',
    require   => Class['postgresql::server::contrib'],
  }
}
