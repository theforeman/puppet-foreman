# = Foreman Remote Execution Cockpit plugin
#
# Installs remote execution cockpit plugin
#
# === Parameters:
#
# $origins::             Specify additional Cockpit Origins to configure cockpit.conf.
#                        The $foreman_url is included by default.
#
# === Advanced parameters:
#
# $ensure::              Specify the package state, or absent/purged to remove it
#
class foreman::plugin::remote_execution::cockpit (
  Optional[String[1]] $ensure = undef,
  Array[Stdlib::HTTPUrl] $origins = [],
) {
  $ensure_absent = $ensure in ['absent', 'purged']

  unless $ensure_absent {
    require foreman::plugin::remote_execution
  }

  $config_directory = '/etc/foreman/cockpit'
  $foreman_url = $foreman::foreman_url
  $cockpit_path = '/webcon'
  $cockpit_host = '127.0.0.1'
  $cockpit_port = 19090
  $cockpit_config = {
    'foreman_url' => $foreman_url,
    'ssl_ca_file' => $foreman::server_ssl_chain,
    'ssl_certificate' => $foreman::client_ssl_cert,
    'ssl_private_key' => $foreman::client_ssl_key,
  }
  $cockpit_origins = [$foreman_url] + $origins

  foreman::plugin { 'remote_execution-cockpit':
    version => $ensure,
  }

  unless $ensure_absent {
    service { 'foreman-cockpit':
      ensure    => running,
      enable    => true,
      require   => Foreman::Plugin['remote_execution-cockpit'],
      subscribe => File["${config_directory}/cockpit.conf", "${config_directory}/foreman-cockpit-session.yml"],
    }
  }

  $file_ensure = bool2str($ensure_absent, 'absent', 'file')

  file { "${config_directory}/cockpit.conf":
    ensure  => $file_ensure,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('foreman/remote_execution_cockpit.conf.erb'),
    require => Foreman::Plugin['remote_execution-cockpit'],
  }

  file { "${config_directory}/foreman-cockpit-session.yml":
    ensure  => $file_ensure,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => foreman::to_symbolized_yaml($cockpit_config),
    require => Foreman::Plugin['remote_execution-cockpit'],
  }

  if $ensure_absent {
    foreman_config_entry { 'remote_execution_cockpit_url':
      value          => '',
      ignore_missing => true,
      require        => Class['foreman::database'],
    }
  } else {
    include apache::mod::proxy_http
    foreman::config::apache::fragment { 'cockpit':
      ssl_content => template('foreman/cockpit-apache-ssl.conf.erb'),
    }

    foreman_config_entry { 'remote_execution_cockpit_url':
      value   => "${cockpit_path}/=%{host}",
      require => Class['foreman::database'],
    }
  }
}
