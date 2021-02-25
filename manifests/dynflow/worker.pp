# @summary Initialize the dynflow worker
#
# @param service_name
#   The name of the service instance. Will get prefixed with dynflow-sidekiq@
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
#
# @param service_ensure
#   The state of the service to ensuree
#
# @param service_enable
#   Whether to enable the service. This means starting at boot
define foreman::dynflow::worker (
  String $service_name = $name,
  Integer[1] $concurrency = $foreman::dynflow_pool_size,
  Array[String] $queues = ['["default", 1]', '["remote_execution", 1]'],
  String $config_owner = 'root',
  String $config_group = $foreman::group,
  Stdlib::Ensure::Service $service_ensure = $foreman::jobs_service_ensure,
  Boolean $service_enable = $foreman::jobs_service_enable
) {

  file { "/etc/foreman/dynflow/${service_name}.yml":
    ensure  => file,
    owner   => $config_owner,
    group   => $config_group,
    mode    => '0644',
    content => template('foreman/dynflow_worker.yml.erb'),
  }
  ~> service { "dynflow-sidekiq@${service_name}":
    ensure    => $service_ensure,
    enable    => $service_enable,
    subscribe => Class['foreman::database'],
  }
}
