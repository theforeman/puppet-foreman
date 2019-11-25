# Set up the foreman database
class foreman::database {
  if $::foreman::db_manage {
    $db_class = "foreman::database::${::foreman::db_type}"

    contain $db_class

    if $::foreman::db_manage_rake {
      Class[$db_class] ~> Foreman_config_entry['db_pending_migration']
    }
  }

  if $::foreman::db_manage_rake {
    $seed_env = {
      'SEED_ADMIN_USER'       => $::foreman::initial_admin_username,
      'SEED_ADMIN_PASSWORD'   => $::foreman::initial_admin_password,
      'SEED_ADMIN_FIRST_NAME' => $::foreman::initial_admin_first_name,
      'SEED_ADMIN_LAST_NAME'  => $::foreman::initial_admin_last_name,
      'SEED_ADMIN_EMAIL'      => $::foreman::initial_admin_email,
      'SEED_ORGANIZATION'     => $::foreman::initial_organization,
      'SEED_LOCATION'         => $::foreman::initial_location,
    }

    foreman_config_entry { 'db_pending_migration':
      value => false,
      dry   => true,
    }
    ~> foreman::rake { 'db:migrate':
      unless => '/usr/bin/test -f /etc/foreman/database_migrated',
    } ~>
    file { '/etc/foreman/database_migrated':
      ensure  => 'present',
      replace => 'no',
      content => Timestamp.new().strftime('%Y-%m-%dT%H:%M:%S%:z'),
      mode    => '0644',
    }
    ~> foreman_config_entry { 'db_pending_seed':
      value => false,
      dry   => true,
    } ~>
    file { '/etc/foreman/database_seeded':
      ensure  => 'present',
      replace => 'no',
      content => Timestamp.new().strftime('%Y-%m-%dT%H:%M:%S%:z'),
      mode    => '0644',
    }
    ~> foreman::rake { 'db:seed':
      environment => delete_undef_values($seed_env),
      unless => '/usr/bin/test -f /etc/foreman/database_seeded',
    }
    ~> Foreman::Rake['apipie:cache:index']
  }
}
