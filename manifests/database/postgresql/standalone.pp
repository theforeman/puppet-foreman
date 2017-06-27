# Set up the foreman standalone database using postgresql
class foreman::database::postgresql::standalone {
  include ::postgresql::client, ::postgresql::server

  postgresql::server::db { $::foreman::database::postgresql::dbname:
    user     => $::foreman::db_username,
    password => $::foreman::database::postgresql::password,
    owner    => $::foreman::db_username,
    encoding => 'utf8',
    locale   => 'en_US.utf8',
  }

}
