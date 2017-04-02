# provides pg_hba rules for the Foreman app
#
#  === Parameters:
#
#  $address::  Address to allow access from
#
define foreman::database::postgresql::db_access(
  $address=$name,
) {
  postgresql::server::pg_hba_rule { "allow ${address} access to ${::foreman::database::postgresql::dbname} database":
    description => "Open up PostgreSQL for access from ${address}",
    type        => 'host',
    database    => $::foreman::database::postgresql::dbname,
    user        => $::foreman::db_username,
    address     => $address,
    auth_method => 'md5',
  }

  postgresql::server::pg_hba_rule { "allow replication from ${address}":
    description => "Open replication access from ${address}",
    type        => 'host',
    database    => 'replication',
    user        => $::foreman::db_replication_username,
    address     => $address,
    auth_method => 'md5',
  }
}
