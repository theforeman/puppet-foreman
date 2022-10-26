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
define foreman::rake (
  Hash[String, String] $environment = {},
  Optional[Integer[0]] $timeout  = undef,
  String[1] $user = $foreman::user,
  Stdlib::Absolutepath $app_root = $foreman::app_root,
  Variant[Undef, String[1], Array[String[1]]] $unless = undef,
) {
  exec { "foreman-rake-${title}":
    command     => "/usr/sbin/foreman-rake ${title}",
    user        => $user,
    environment => sort(join_keys_to_values({ 'HOME' => $app_root } + $environment, '=')),
    logoutput   => 'on_failure',
    refreshonly => $unless =~ Undef,
    timeout     => $timeout,
    unless      => $unless,
  }
}
