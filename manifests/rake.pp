# Run a Foreman rake task when notified
define foreman::rake(

  $done_file = "${::foreman::data_root}/${title}_done"

  ) {

  exec { "foreman-rake-${title}":
    command     => "/usr/sbin/foreman-rake ${title} && /bin/touch ${done_file}",
    provider    => 'shell',
    user        => $::foreman::user,
    environment => "HOME=${::foreman::app_root}",
    logoutput   => 'on_failure',
    creates     => $done_file,
  }

}
