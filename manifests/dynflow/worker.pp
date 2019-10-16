# Initialize the dynflow worker
# @param concurrency
#   Defines number of threads used for job processing
define foreman::dynflow::worker (
  String $service_name = $name,
  Integer[1] $concurrency = $foreman::dynflow_pool_size,
  Array[String] $queues = ['default', 'remote_execution'],
  String $config_owner = 'root',
  String $config_group = $::foreman::group,
  Stdlib::Ensure::Service $service_ensure = $::foreman::jobs_service_ensure,
  Boolean $service_enable = $::foreman::jobs_service_enable
) {

  file { "/etc/foreman/dynflow/${service_name}.yml":
    ensure  => file,
    owner   => $config_owner,
    group   => $config_group,
    mode    => '0644',
    content => template('foreman/dynflow_worker.yml.erb'),
  }

  service { "dynflow-sidekiq@${service_name}":
    ensure => $service_ensure,
    enable => $service_enable,
  }
}
