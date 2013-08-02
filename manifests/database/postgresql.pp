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

  # Postgresql::Params<| |> -> Postgresql::Server<| |>
  # Postgresql::Params<| |> -> Postgresql::Client<| |>

  # create database resources, but leave room for user-infused parameters.
  $dbp  = $::foreman::raw_db_parameters
  if has_key($dbp, "postgresql::params") {
    validate_hash($dbp['postgresql::params'])
    $par_params = $dbp['postgresql::params']
  } else {
    $par_params = {}
  }
  create_resources('class', { 'postgresql::params' => $par_params } )

  if has_key($dbp, "postgresql::server") {
    validate_hash($dbp['postgresql::server'])
    $srv_params = $dbp['postgresql::server']
  } else {
    $srv_params = {}
  }
  create_resources('class', { 'postgresql::server' => $srv_params } )

  if has_key($dbp, "postgresql::client") {
    validate_hash($dbp['postgresql::client'])
    $cli_params = $dbp['postgresql::client']
  } else {
    $cli_params = {}
  }
  create_resources('class', { 'postgresql::client' => $cli_params } )

  Class['postgresql::params'] -> Class['postgresql::server']
  Class['postgresql::params'] -> Class['postgresql::client']

  postgresql::db { $dbname:
    user     => $foreman::db_username,
    password => $password,
  }
}
