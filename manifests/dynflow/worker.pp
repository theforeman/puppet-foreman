# @summary manage a dynflow worker
#
# @param ensure
#   The state to ensure for this worker
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
# @api private
define foreman::dynflow::worker (
  Enum['present', 'absent'] $ensure = 'present',
  String $service_name = $name,
  Integer[1] $concurrency = 1,
  Array[Variant[String[1], Tuple[String, Integer[0]]]] $queues = [],
  String[1] $config_owner = 'root',
  Optional[String[1]] $config_group = undef,
  Stdlib::Filemode $config_mode = '0644',
) {
  $filename = "/etc/foreman/dynflow/${service_name}.yml"
  $service = "dynflow-sidekiq@${service_name}"

  if $ensure == 'present' {
    assert_type(Array[Variant[String[1], Tuple[String, Integer[0]]], 1], $queues)

    $config = {
      'concurrency' => $concurrency,
      'queues'      => $queues,
    }

    file { $filename:
      ensure  => file,
      owner   => $config_owner,
      group   => pick($config_group, $foreman::group),
      mode    => $config_mode,
      content => foreman::to_symbolized_yaml($config),
    }
    ~> service { $service:
      ensure    => running,
      enable    => true,
      subscribe => Class['foreman::database'],
    }

    Service <| tag == 'postgresql::server::service' |> ~> Service[$service]
  } else {
    service { $service:
      ensure => stopped,
      enable => false,
    }
    -> file { $filename:
      ensure => absent,
    }
  }
}
