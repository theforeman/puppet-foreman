# @summary Set up the foreman database
# @api private
class foreman::database(
  Integer[0] $timeout = 3600,
) {
  if $foreman::db_manage {
    contain foreman::database::postgresql

    if $foreman::db_manage_rake {
      Class['foreman::database::postgresql'] ~> Foreman::Rake['db:migrate']
    }
  }

  if $foreman::db_manage_rake {
    $seed_env = {
      'SEED_ADMIN_USER'       => $foreman::initial_admin_username,
      'SEED_ADMIN_PASSWORD'   => $foreman::initial_admin_password,
      'SEED_ADMIN_FIRST_NAME' => $foreman::initial_admin_first_name,
      'SEED_ADMIN_LAST_NAME'  => $foreman::initial_admin_last_name,
      'SEED_ADMIN_EMAIL'      => $foreman::initial_admin_email,
      'SEED_ADMIN_LOCALE'     => $foreman::initial_admin_locale,
      'SEED_ADMIN_TIMEZONE'   => $foreman::initial_admin_timezone,
      'SEED_ORGANIZATION'     => $foreman::initial_organization,
      'SEED_LOCATION'         => $foreman::initial_location,
    }

    foreman::rake { 'db:migrate':
      timeout => $timeout,
      unless  => '/usr/sbin/foreman-rake db:abort_if_pending_migrations',
      notify  => Foreman::Rake['apipie:cache:index', 'apipie_dsl:cache', 'db:seed'],
    }
    ~> foreman_config_entry { 'db_pending_seed':
      value => false,
      dry   => true,
    }
    ~> foreman::rake { 'db:seed':
      environment => delete_undef_values($seed_env),
      notify      => Foreman::Rake['apipie:cache:index', 'apipie_dsl:cache'],
    }
  }
}
