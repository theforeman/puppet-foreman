# @summary Configure the foreman service
# @api private
class foreman::service(
  Boolean $apache = $foreman::apache,
  Boolean $passenger = $foreman::passenger,
  Stdlib::Absolutepath $app_root = $foreman::app_root,
  Boolean $ssl = $foreman::ssl,
  Boolean $use_foreman_service = $foreman::use_foreman_service,
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
      queues      => ['default', 'remote_execution'],
      instances   => $dynflow_worker_instances,
      concurrency => $dynflow_worker_concurrency,
    }
  }

  if $apache {
    if $passenger {
      exec {'restart_foreman':
        command     => "/bin/touch ${app_root}/tmp/restart.txt",
        refreshonly => true,
        cwd         => $app_root,
        path        => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
      }
    }

    Class['apache::service'] -> Class['foreman::service']

    # Ensure SSL certs from the puppetmaster are available
    # Relationship is duplicated there as defined() is parse-order dependent
    if $ssl and defined(Class['puppet::server::config']) {
      Class['puppet::server::config'] -> Class['foreman::service']
    }
  }

  if $use_foreman_service {
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
}
