# Set up the foreman database using postgresql
class foreman::database::postgresql {
  $dbname = $::foreman::db_database ? {
    'UNSET' => 'foreman',
    default => $::foreman::db_database,
  }

  $password = $::foreman::db_password ? {
    'UNSET' => false,
    default => postgresql_password($::foreman::db_username, $::foreman::db_password),
  }

  $replication_password = postgresql_password($::foreman::db_replication_username, $::foreman::db_replication_password)

  $port = $::foreman::db_port ? {
    'UNSET' => 5432,
    default => $::foreman::db_port,
  }

  # Prevents errors if run from /root etc.
  Postgresql_psql {
    cwd => '/',
  }

  class { "foreman::database::postgresql::${::foreman::db_node_type}": }

  unless $::foreman::db_host == 'UNSET' {
    postgresql::validate_db_connection { 'validate postgres connection':
      database_host     => $::foreman::db_host,
      database_username => $::foreman::db_username,
      database_password => $::foreman::db_password,
      database_name     => $dbname,
      database_port     => $port,
    }
  }
}
