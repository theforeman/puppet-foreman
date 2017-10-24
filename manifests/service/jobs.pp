# = Jobs service
#
# Service to start a Dynflow daemon for background job processing in Foreman.
#
# === Parameters:
#
# $service:: The name of the service
#
# $dynflow_in_core:: Whether the dynflow is integrated into core. This affects
#                    the autodetection of the service name.
#
# $ensure:: State the service should be in
#
# $enable:: Whether to enable the service or not

class foreman::service::jobs(
  Optional[String] $service = $::foreman::jobs_service,
  Boolean $dynflow_in_core = $::foreman::dynflow_in_core,
  Enum['running', 'stopped'] $ensure = $::foreman::jobs_service_ensure,
  Boolean $enable = $::foreman::jobs_service_enable,
) {
  if $service {
    $_service = $service
  } else {
    if $dynflow_in_core {
      $_service = 'dynflowd'
    } else{
      $_service = $::osfamily ? {
        'Debian' => 'ruby-foreman-tasks',
        default  => 'foreman-tasks',
      }
    }
  }

  service { $_service:
    ensure => $ensure,
    enable => $enable,
  }
}
