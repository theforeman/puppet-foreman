# Run a Foreman rake task when notified
define foreman::rake($environment = {}) {
  validate_hash($environment)
  exec { "foreman-rake-${title}":
    command     => "/usr/sbin/foreman-rake ${title}",
    user        => $::foreman::user,
    environment => sort(join_keys_to_values(merge({'HOME' => $::foreman::app_root}, $environment), '=')),
    logoutput   => 'on_failure',
    refreshonly => true,
  }
}
