# @summary Configure the foreman service
# @api private
class foreman::service(
  Boolean $apache = $foreman::apache,
  Boolean $ssl = $foreman::ssl,
  String $foreman_service = $foreman::foreman_service,
  Stdlib::Ensure::Service $foreman_service_ensure = $foreman::foreman_service_ensure,
  Boolean $foreman_service_enable = $foreman::foreman_service_enable,
  Boolean $dynflow_manage_services = $foreman::dynflow_manage_services,
  Enum['present', 'absent'] $dynflow_orchestrator_ensure = $foreman::dynflow_orchestrator_ensure,
  Integer[0] $dynflow_worker_instances = $foreman::dynflow_worker_instances,
  Integer[0] $dynflow_worker_concurrency = $foreman::dynflow_worker_concurrency,
) {
  if $dynflow_manage_services {
    foreman::dynflow::worker { 'orchestrator':
      ensure      => $dynflow_orchestrator_ensure,
      concurrency => 1,
      queues      => ['dynflow_orchestrator'],
    }

    foreman::dynflow::pool { 'worker':
      queues      => [['default', 1], ['remote_execution', 1]],
      instances   => $dynflow_worker_instances,
      concurrency => $dynflow_worker_concurrency,
    }
  }

  service { "${foreman_service}.socket":
    ensure => $foreman_service_ensure,
    enable => $foreman_service_enable,
  }

  service { $foreman_service:
    ensure  => $foreman_service_ensure,
    enable  => $foreman_service_enable,
    require => Service["${foreman_service}.socket"],
  }
}
