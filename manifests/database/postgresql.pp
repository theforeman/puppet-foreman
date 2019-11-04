# Set up the foreman database using postgresql
class foreman::database::postgresql {
  case $::osfamily {
    'RedHat': {
      if $::operatingsystemrelease =~ /^7/ {
        class { 'postgresql::globals':
          version => '10',
          client_package_name => 'rh-postgresql10-postgresql-syspaths',
          server_package_name => 'rh-postgresql10-postgresql-server-syspaths',
          contrib_package_name => 'rh-postgresql10-postgresql-contrib-syspaths',
          service_name => 'postgresql',
          datadir => '/var/lib/pgsql/data',
          confdir => '/var/lib/pgsql/data',
          bindir => '/usr/bin',
        }
      }
    }
  }

  $dbname = $::foreman::db_database ? {
    'UNSET' => 'foreman',
    default => $::foreman::db_database,
  }

  $password = $::foreman::db_password ? {
    'UNSET' => false,
    default => postgresql_password($::foreman::db_username, $::foreman::db_password),
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
