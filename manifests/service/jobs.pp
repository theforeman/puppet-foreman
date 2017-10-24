# = Jobs service
#
# Service to start a Dynflow daemon for background job processing in Foreman.
#
# === Parameters:
#
# $service:: The name of the service
#
# $ensure:: State the service should be in
#
# $enable:: Whether to enable the service or not

class foreman::service::jobs(
  Optional[String] $service = undef,
  Enum['running', 'stopped'] $ensure = 'running',
  Boolean $enable = true,
) {
  if $service {
    $_service = $service
  } else {
    $_service = $::osfamily ? {
      'Debian' => 'ruby-foreman-tasks',
      default  => 'foreman-tasks',
    }
  }

  service { $_service:
    ensure => $ensure,
    enable => $enable,
  }
}
