# Set up the foreman slave database using postgresql
class foreman::database::postgresql::slave(
  $wal_keep_segments = 256
) {
  require ::postgresql::params

  $db_all_cluster_hostnames = unique(concat($::foreman::db_cluster_hostnames, $::fqdn))

  file { 'Write .pgpass':
    content => "*:*:*:${::foreman::db_replication_username}:${::foreman::db_replication_password}\n",
    path    => "${::foreman::params::postgres_home}/.pgpass",
    owner   => $::postgresql::params::user,
    group   => $::postgresql::params::group,
    mode    => '0600',
  }
  -> exec { 'Initialize new postgresql cluster':
    command => "${::postgresql::params::bindir}/pg_basebackup -w -c fast -X stream -h ${::foreman::db_host} -p ${::foreman::database::postgresql::port} -U ${::foreman::db_replication_username} -D ${::postgresql::params::datadir}",
    creates => "${::postgresql::params::datadir}/base",
    user    => $::postgresql::params::user,
  }
  -> class {'::postgresql::server':
    listen_addresses     => '*',
    manage_recovery_conf => true,
    needs_initdb         => false,
  }

  postgresql::server::recovery { 'Configure recovery.conf':
    standby_mode     => 'on',
    primary_conninfo => "host=${::foreman::db_host} port=${::foreman::database::postgresql::port} user=${::foreman::db_replication_username} password=${::foreman::db_replication_password}",
    trigger_file     => "${::postgresql::params::datadir}/failover",
  }

  postgresql::server::role { $::foreman::db_username:
    password_hash => $::foreman::database::postgresql::password,
  }

  foreman::database::postgresql::db_access { $db_all_cluster_hostnames: }

  postgresql::server::role { $::foreman::db_replication_username:
    password_hash => $::foreman::database::postgresql::replication_password,
    replication   => true,
  }

  postgresql::server::config_entry { 'wal_level':
    value => 'hot_standby',
  }

  postgresql::server::config_entry { 'max_wal_senders':
    value => count($db_all_cluster_hostnames),
  }

  postgresql::server::config_entry { 'wal_keep_segments':
    value => $wal_keep_segments,
  }

  postgresql::server::config_entry { 'hot_standby':
    value => 'on',
  }

}
