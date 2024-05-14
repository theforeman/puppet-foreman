# @summary Configure the foreman service
# @api private
class foreman::service (
  Boolean $apache = $foreman::apache,
  Boolean $ssl = $foreman::ssl,
  String[1] $foreman_service = $foreman::foreman_service,
  Stdlib::Ensure::Service $foreman_service_ensure = 'running',
  Boolean $foreman_service_enable = true,
  Boolean $dynflow_manage_services = $foreman::dynflow_manage_services,
  Enum['present', 'absent'] $dynflow_orchestrator_ensure = $foreman::dynflow_orchestrator_ensure,
  Integer[0] $dynflow_worker_instances = $foreman::dynflow_worker_instances,
  Integer[0] $dynflow_worker_concurrency = $foreman::dynflow_worker_concurrency,
  Enum['package', 'container'] $deployment_mode = $foreman::deployment_mode,
  String[1] $container_image = 'quay.io/evgeni/foreman-rpm:latest',
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

  if $apache {
    Class['apache::service'] -> Class['foreman::service']

    # Ensure SSL certs from the puppetmaster are available
    # Relationship is duplicated there as defined() is parse-order dependent
    if $ssl and defined(Class['puppet::server::config']) {
      Class['puppet::server::config'] -> Class['foreman::service']
    }
  }

  if $deployment_mode == 'package' {
    service { "${foreman_service}.socket":
      ensure => $foreman_service_ensure,
      enable => $foreman_service_enable,
    }

    service { $foreman_service:
      ensure => $foreman_service_ensure,
      enable => $foreman_service_enable,
      before => Service["${foreman_service}.socket"],
    }
  } else {
    file { '/etc/containers/systemd':
      ensure => directory,
    }
    podman::quadlet { 'foreman.container':
      ensure          => present,
      unit_entry      => {
        'Description' => 'Foreman',
      },
      service_entry   => {
        'TimeoutStartSec' => '900',
      },
      container_entry => {
        'Image'         => $container_image,
        'Volume'        => ['/etc/foreman/:/etc/foreman/'],
        'AddCapability' => ['CAP_DAC_OVERRIDE', 'CAP_IPC_OWNER'],
        'Network'       => 'host',
        'HostName'      => $foreman::servername,
        'Notify'        => true,
      },
      install_entry   => {
        'WantedBy' => 'default.target',
      },
      active          => true,
    }
  }
}
