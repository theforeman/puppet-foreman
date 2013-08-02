# Set up the mysql database for foreman
class foreman::database::mysql {
  $dbname = $foreman::db_database ? {
    'UNSET' => 'foreman',
    default => $foreman::db_database,
  }

  # create database resources, but leave room for user-infused parameters.
  $dbp = $::foreman::raw_db_parameters
  $hash = {}
  $std_params = has_key($dbp, "mysql::server") ? {
    true    => $dbp['mysql::server'], 
    default => $hash
  }
  $srv_params = has_key($dbp, "mysql") ? {
    true    => $dbp['mysql'], 
    default => $hash
  }
  create_resources('class', { "mysql::server" => $std_params })
  create_resources('class', { "mysql"         => $srv_params })

  # has no parameters. simply include.
  include mysql::server::account_security

  mysql::db { $dbname:
    user     => $foreman::db_username,
    password => $foreman::db_password,
  }
}
