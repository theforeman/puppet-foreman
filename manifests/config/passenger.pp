class foreman::config::passenger {
  include apache::ssl
  include ::passenger

  file {"foreman_vhost":
    path    => "${foreman::params::apache_conf_dir}/foreman.conf",
    content => template("foreman/foreman-vhost.conf.erb"),
    mode    => 644,
    notify  => Exec["reload-apache"],
  }

  exec {"restart_foreman":
    command     => "/bin/touch ${foreman::params::app_root}/tmp/restart.txt",
    refreshonly => true,
    cwd         => $foreman::params::app_root,
    path        => "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin",
    require     => Class["foreman::install"]
  }

  # passenger ~2.10 will not load the app if a config.ru doesn't exist in the app
  # root. Also, passenger will run as suid to the owner of the config.ru file.
  file {
    "$foreman::params::app_root/config.ru":
      ensure => link,
      owner  => $foreman::params::user,
      target => "${foreman::params::app_root}/vendor/rails/railties/dispatches/config.ru";
    "$foreman::params::app_root/config/environment.rb":
      owner   => $foreman::params::user,
      require => Class["foreman::install"];
  }

}
