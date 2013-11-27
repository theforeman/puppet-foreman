# Run a Foreman rake task when notified
define foreman::rake() {
  exec { "foreman-rake-${title}":
    command     => "/usr/sbin/foreman-rake ${title}",
    user        => $::foreman::user,
    environment => "HOME=${::foreman::app_root}",
    logoutput   => 'on_failure',
    refreshonly => true,
  }
}
