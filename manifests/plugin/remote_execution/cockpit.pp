# Installs remote execution cockpit plugin
class foreman::plugin::remote_execution::cockpit {
  require foreman::plugin::remote_execution

  $config_directory = '/etc/foreman/cockpit'
  $foreman_url = $foreman::foreman_url
  $cockpit_path = '/webcon'
  $cockpit_host = '127.0.0.1'
  $cockpit_port = 9999
  $cockpit_config = {
    'foreman_url' => $foreman_url,
    'ssl_ca_file' => $foreman::client_ssl_ca,
    'ssl_certificate' => $foreman::client_ssl_cert,
    'ssl_private_key' => $foreman::client_ssl_key,
  }

  foreman::plugin { 'remote_execution-cockpit': }
  -> service { 'foreman-cockpit':
    ensure => running,
    enable => true,
  }

  file { "${config_directory}/cockpit.conf":
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('foreman/remote_execution_cockpit.conf.erb'),
    require => Foreman::Plugin['remote_execution-cockpit'],
    notify  => Service['foreman-cockpit'],
  }

  file { "${config_directory}/foreman-cockpit-session.yml":
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('foreman/remote_execution_cockpit_session.yml.erb'),
    require => Foreman::Plugin['remote_execution-cockpit'],
    notify  => Service['foreman-cockpit'],
  }

  include apache::mod::proxy_wstunnel
  include apache::mod::proxy_http
  foreman::config::apache::fragment { 'cockpit':
    ssl_content => template('foreman/cockpit-apache-ssl.conf.erb'),
  }

  foreman_config_entry { 'remote_execution_cockpit_url':
    value => "/${cockpit_path}/=%{host}",
  }
}
