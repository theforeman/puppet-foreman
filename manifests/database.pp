# Set up the foreman database
class foreman::database {
  if $foreman::db_manage {
    $db_class = "foreman::database::${foreman::db_type}"

    class { $db_class: } ~>
    foreman::rake { 'db:migrate': } ->
    foreman::rake { 'db:seed': }
  } else {
    # DataCentred
    file { '/usr/share/foreman/db_initialised':
      ensure => file,
    } ~>
    foreman::rake { 'db:migrate': } ->
    foreman::rake { 'db:seed': }
  }
}
