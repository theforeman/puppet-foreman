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

  if $::foreman::db_root_cert {
    $pg_cert_dir = "${::foreman::app_root}/.postgresql"

    file { $pg_cert_dir:
      ensure => 'directory',
      owner  => 'root',
      group  => $::foreman::group,
      mode   => '0640',
    }

    file { "${pg_cert_dir}/root.crt":
      ensure => file,
      source => $::foreman::db_root_cert,
      owner  => 'root',
      group  => $::foreman::group,
      mode   => '0640',
    }
  }

  # Prevents errors if run from /root etc.
  Postgresql_psql {
    cwd => '/',
  }

  include ::postgresql::client, ::postgresql::server

  postgresql::server::db { $dbname:
    user     => $::foreman::db_username,
    password => $password,
    owner    => $::foreman::db_username,
    encoding => 'utf8',
    locale   => 'en_US.utf8',
  }
}
