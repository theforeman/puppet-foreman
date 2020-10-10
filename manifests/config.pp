# Configure foreman
class foreman::config {
  # Ensure 'puppet' user group is present before managing foreman user
  # Relationship is duplicated there as defined() is parse-order dependent
  if defined(Class['puppet::server::install']) {
    Class['puppet::server::install'] -> Class['foreman::config']
  }

  if $foreman::dynflow_manage_services {
    if $foreman::dynflow_redis_url != undef {
      $dynflow_redis_url = $foreman::dynflow_redis_url
    } else {
      include redis
      $dynflow_redis_url = "redis://localhost:${redis::port}/6"
    }

    file { '/etc/foreman/dynflow':
      ensure => directory,
    }
  }

  # Used in the settings template
  $websockets_ssl_cert = pick($foreman::websockets_ssl_cert, $foreman::server_ssl_cert)
  $websockets_ssl_key = pick($foreman::websockets_ssl_key, $foreman::server_ssl_key)

  concat::fragment {'foreman_settings+01-header.yaml':
    target  => '/etc/foreman/settings.yaml',
    content => template('foreman/settings.yaml.erb'),
    order   => '01',
  }

  concat {'/etc/foreman/settings.yaml':
    owner => 'root',
    group => $foreman::group,
    mode  => '0640',
  }

  $db_pool = max($foreman::db_pool, $foreman::foreman_service_puma_threads_max)

  file { '/etc/foreman/database.yml':
    owner   => 'root',
    group   => $foreman::group,
    mode    => '0640',
    content => template('foreman/database.yml.erb'),
  }

  systemd::dropin_file { 'foreman-service':
    filename => 'installer.conf',
    unit     => "${foreman::foreman_service}.service",
    content  => template('foreman/foreman.service-overrides.erb'),
  }

  file { $foreman::app_root:
    ensure  => directory,
  }

  if $foreman::db_root_cert {
    $pg_cert_dir = "${foreman::app_root}/.postgresql"

    file { $pg_cert_dir:
      ensure => 'directory',
      owner  => 'root',
      group  => $foreman::group,
      mode   => '0640',
    }

    file { "${pg_cert_dir}/root.crt":
      ensure => file,
      source => $foreman::db_root_cert,
      owner  => 'root',
      group  => $foreman::group,
      mode   => '0640',
    }
  }

  if $foreman::manage_user {
    if $foreman::puppet_ssldir in $foreman::server_ssl_key or $foreman::puppet_ssldir in $foreman::client_ssl_key {
      $_user_groups = $foreman::user_groups + ['puppet']
    } else {
      $_user_groups = $foreman::user_groups
    }

    group { $foreman::group:
      ensure => 'present',
    }
    user { $foreman::user:
      ensure  => 'present',
      shell   => '/bin/false',
      comment => 'Foreman',
      home    => $foreman::app_root,
      gid     => $foreman::group,
      groups  => unique($_user_groups),
    }
  }

  if $foreman::apache {
    $foreman_socket_override = template('foreman/foreman.socket-overrides.erb')

    if $foreman::ipa_authentication {
      concat::fragment { 'foreman_settings+02-authorize_login_delegation.yaml':
        target  => '/etc/foreman/settings.yaml',
        content => template('foreman/settings-external-auth.yaml.erb'),
        order   => '02',
      }
    }
  } else {
    $foreman_socket_override = undef
  }

  systemd::dropin_file { 'foreman-socket':
    ensure   => bool2str($foreman_socket_override =~ Undef, 'absent', 'present'),
    filename => 'installer.conf',
    unit     => "${foreman::foreman_service}.socket",
    content  => $foreman_socket_override,
  }
}
