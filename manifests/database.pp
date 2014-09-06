# Set up the foreman database
class foreman::database {
  if $::foreman::db_manage {
    validate_string($::foreman::admin_username, $::foreman::admin_password)

    $db_class = "foreman::database::${::foreman::db_type}"
    $seed_env = {
      'SEED_ADMIN_USER'       => $::foreman::admin_username,
      'SEED_ADMIN_PASSWORD'   => $::foreman::admin_password,
      'SEED_ADMIN_FIRST_NAME' => $::foreman::admin_first_name,
      'SEED_ADMIN_LAST_NAME'  => $::foreman::admin_last_name,
      'SEED_ADMIN_EMAIL'      => $::foreman::admin_email,
      'SEED_ORGANIZATION'     => $::foreman::initial_organization,
      'SEED_LOCATION'         => $::foreman::initial_location,
    }

    class { $db_class: } ~>
    foreman::rake { 'db:migrate': } ~>
    foreman::rake { 'db:seed':
      environment => delete_undef_values($seed_env),
    } ~>
    foreman::rake { 'apipie:cache': }
  }
}
