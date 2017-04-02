# Set up the foreman master database using postgresql
class foreman::database::postgresql::master(
  $wal_keep_segments = 256
) {
  $db_all_cluster_hostnames = unique(concat($::foreman::db_cluster_hostnames, $::fqdn))

  class {'::postgresql::server':
    listen_addresses => '*',
  }

  if $::foreman::db_synchronous_names {
    postgresql::server::config_entry { 'synchronous_standby_names':
      value => join($::foreman::db_synchronous_names, ','),
    }
  }

  postgresql::server::db { $::foreman::database::postgresql::dbname:
    user     => $::foreman::db_username,
    password => $::foreman::database::postgresql::password,
    owner    => $::foreman::db_username,
    encoding => 'utf8',
    locale   => 'en_US.utf8',
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
