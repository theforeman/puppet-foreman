# Set up the foreman database
class foreman::database {
  if $foreman::db_manage {
    $db_class = "foreman::database::${foreman::db_type}"

    class { $db_class: } ~>
    foreman::rake { 'db:migrate': } ~>
    foreman::rake { 'db:seed': } ~>
    foreman::rake { 'apipie:cache': }
  }
}
