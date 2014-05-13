# Parameters for Foreman CLI class
class foreman::cli::params {
  $foreman_url = undef
  $manage_root_config = true
  $username = 'admin'
  $password = 'changeme'
  $refresh_cache = false
  $request_timeout = 120
}
