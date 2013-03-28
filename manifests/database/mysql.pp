class foreman::database::mysql {
  $dbname = $foreman::db_database ? {
    'UNSET' => 'foreman',
    default => $foreman::db_database,
  }

  include mysql, mysql::server, mysql::server::account_security
  mysql::db { $dbname:
    user     => $foreman::db_username,
    password => $foreman::db_password,
  }
}
