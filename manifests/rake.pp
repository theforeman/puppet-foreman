# @summary Run a Foreman rake task when notified
#
# @param environment
#   Environment variables to set
# @param timeout
#   The timeout to set on the exec resource
# @param user
#   The user to run this rake task
# @param app_root
#   The application root to use
# @param unless
#   Don't execute the rake task if this command passes. If not passed in, the
#   exec is refreshonly.
define foreman::rake(
  Hash[String, String] $environment = {},
  $timeout  = undef,
  $user     = $foreman::user,
  $app_root = $foreman::app_root,
  $unless   = undef,
) {
  # https://github.com/rodjek/puppet-lint/issues/327
  # lint:ignore:arrow_alignment
  exec { "foreman-rake-${title}":
    command     => "/usr/sbin/foreman-rake ${title}",
    user        => $user,
    environment => sort(join_keys_to_values(merge({'HOME' => $app_root}, $environment), '=')),
    logoutput   => 'on_failure',
    refreshonly => $unless =~ Undef,
    timeout     => $timeout,
    unless      => $unless,
  }
  # lint:endignore
}
