# Set up the foreman database using postgresql
class foreman::database::postgresql {
  $dbname = $foreman::db_database ? {
    'UNSET' => 'foreman',
    default => $foreman::db_database,
  }

  $password = $foreman::db_password ? {
    'UNSET' => false,
    default => postgresql::postgresql_password($foreman::db_username, $foreman::db_password),
  }

  # Prevents errors if run from /root etc.
  Postgresql_psql {
    cwd => '/',
  }

  include postgresql::client, postgresql::server

  postgresql::server::db { $dbname:
    user     => $foreman::db_username,
    password => $password,
    owner    => $foreman::db_username,
    encoding => 'utf8',
    locale   => 'en_US.utf8',
  }

  if $facts['os']['family'] == 'RedHat' and $facts['os']['release']['major'] == '7' {
    file { '/etc/systemd/system/rh-postgresql12-postgresql.service.d':
      ensure => link,
      target => '/etc/systemd/system/postgresql.service.d',
    }
  }
}
