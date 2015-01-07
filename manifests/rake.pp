# Run a Foreman rake task when notified
define foreman::rake($environment = {}, $timeout = undef) {
  validate_hash($environment)

  # https://github.com/rodjek/puppet-lint/issues/327
  # lint:ignore:arrow_alignment
  exec { "foreman-rake-${title}":
    command     => "/usr/sbin/foreman-rake ${title}",
    user        => $::foreman::user,
    environment => sort(join_keys_to_values(merge({'HOME' => $::foreman::app_root}, $environment), '=')),
    logoutput   => 'on_failure',
    refreshonly => true,
    timeout     => $timeout,
  }
  # lint:endignore
}
