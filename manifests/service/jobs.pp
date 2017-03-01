# = Jobs service
#
# Service to start a Dynflow executor for background job
# processing in Foreman.
#
# On foreman 1.16+ this runs the dynflow-executor. This class could be
# renamed to dynflow-executor when this module has to be compatible with
# 1.16 and 1.17 only
#
# === Parameters:
#
# $service:: Service name
#
# $dynflow_in_core:: Whether Foreman has a dynflow executor
#                    without the foreman-tasks plugin
#
# $ensure:: State the service should be in
#
# $enable:: Whether to enable the service or not

class foreman::service::jobs(
  String $service = $::foreman::jobs_service,
  Boolean $dynflow_in_core = $::foreman::dynflow_in_core,
  Enum['running', 'stopped'] $ensure  = $::foreman::jobs_service_ensure,
  Boolean $enable = $::foreman::jobs_service_enable,
) {
  if $dynflow_in_core and ($service in ['ruby-dynflow-executor', 'dynflow-executor']) or
    !$dynflow_in_core and ($service in ['ruby-foreman-tasks', 'foreman-tasks']) {
    service { $service:
      ensure => $ensure,
      enable => $enable,
      name   => $service,
    }
  }
}
