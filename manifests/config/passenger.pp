class foreman::config::passenger(

  # specifiy which interface to bind passenger to eth0, eth1, ...
  $listen_on_interface = ''


) {
  include apache::ssl
  include ::passenger

  # Check the value in case the interface doesn't exist, otherwise listen on all interfaces
  if inline_template("<%= interfaces.split(',').include?(listen_on_interface) %>") == "true" {
    $listen_interface = inline_template("<%= ipaddress_${listen_on_interface} %>")
  }
  else{
    $listen_interface = '*'
  }

  $foreman_conf = $foreman::use_vhost ? {
    false   => 'foreman/foreman-apache.conf.erb',
    default => 'foreman/foreman-vhost.conf.erb',
  }

  file {'foreman_vhost':
    path    => "${foreman::apache_conf_dir}/foreman.conf",
    content => template($foreman_conf),
    mode    => '0644',
    notify  => Exec['reload-apache'],
    require => Class['foreman::install'],
  }

  exec {'restart_foreman':
    command     => "/bin/touch ${foreman::app_root}/tmp/restart.txt",
    refreshonly => true,
    cwd         => $foreman::app_root,
    path        => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
  }

  file { ["${foreman::app_root}/config.ru", "${foreman::app_root}/config/environment.rb"]:
    owner   => $foreman::user,
    require => Class['foreman::install'],
  }
}
