# Configure the foreman repo
class foreman::repo(
  $repo                = $::foreman::repo,
  $gpgcheck            = $::foreman::gpgcheck,
  $configure_epel_repo = $::foreman::configure_epel_repo,
  $configure_scl_repo  = $::foreman::configure_scl_repo,
) {
  if $repo {
    foreman::repos { 'foreman':
      repo     => $repo,
      gpgcheck => $gpgcheck,
      before   => Class['foreman::repos::extra'],
    }
  }

  class { '::foreman::repos::extra':
    configure_epel_repo => $configure_epel_repo,
    configure_scl_repo  => $configure_scl_repo,
  }
  contain ::foreman::repos::extra
}
