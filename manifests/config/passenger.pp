class foreman::config::passenger {
  include apache::ssl
  include ::passenger

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
