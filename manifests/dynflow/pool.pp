# @summary Manage a pool of Dynflow Sidekiq instances
#
# @param service_name
#   The name of the service instance. Will get prefixed with dynflow-sidekiq@
#   and suffixed with the worker number.
#
# @param instances
#   Defines number of instances used for job processing. Set to 0 to clean up old
#   instances with the service name.
#
# @param concurrency
#   Defines number of threads used for job processing
#
# @param queues
#   The Queues this worker should process
#
# @param config_owner
#   The user who owns the config file
#
# @param config_group
#   The group that owns the config file
define foreman::dynflow::pool (
  String $service_name = $name,
  Integer[0] $instances = $foreman::dynflow_worker_instances,
  Integer[1] $concurrency = $foreman::dynflow_worker_concurrency,
  Array[String[1], 1] $queues = [],
  Optional[String[1]] $config_owner = undef,
  Optional[String[1]] $config_group = undef,
) {
  if $instances >= 1 {
    Integer[1, $instances].each |$n| {
      foreman::dynflow::worker { "${service_name}-${n}":
        ensure       => present,
        concurrency  => $concurrency,
        queues       => $queues,
        config_owner => $config_owner,
        config_group => $config_group,
      }
    }
  }

  # Always clean up the "base" version which may be present from a migration
  foreman::dynflow::worker { $service_name:
    ensure => absent,
  }

  $existing_services = fact('foreman_dynflow')
  if $existing_services {
    $existing_services.each |$instance| {
      if $instance =~ Pattern["^${service_name}-[0-9]+$"] and !defined(Foreman::Dynflow::Worker[$instance]) {
        foreman::dynflow::worker { $instance:
          ensure => absent,
        }
      }
    }
  }
}
