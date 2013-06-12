# Set up the foreman database
class foreman::database {
  if $foreman::db_manage {
    $db_class = "foreman::database::${foreman::db_type}"

    class { $db_class: } ~>
    exec { 'dbmigrate':
      command     => "${foreman::app_root}/extras/dbmigrate",
      user        => $foreman::user,
      environment => "HOME=${foreman::app_root}",
      logoutput   => 'on_failure',
      refreshonly => true,
    }
  }
}
