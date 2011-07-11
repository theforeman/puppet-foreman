class foreman::passenger {
  if $using_passenger {
    include apache2::passenger
    include apache2::ssl
  }

  file{"foreman_vhost":
    path => $lsbdistid ? {
      default => "/etc/httpd/conf.d/foreman.conf",
      "Ubuntu" => "/etc/apache2/conf.d/foreman.conf",
      "Debian" => "/etc/apache2/conf.d/foreman.conf"
    },
    content => template("foreman/foreman-vhost.conf.erb"),
    mode => 644,
    notify => $using_passenger ? {
      true => Exec["reload-apache2"],
      default => undef,
    },
    ensure => $using_passenger ? {
      true => "present",
      default => "absent",
    },
  }

  exec{"restart_foreman":
    command => "/bin/touch $foreman_dir/tmp/restart.txt",
    refreshonly => true
  }

#passenger ~2.10 will not load the app if a config.ru doesn't exist in the app
#root. Also, passenger will run as suid to the owner of the config.ru file.
  case $lsbdistid {
    'Ubuntu','Debian':  {
      file{"${foreman_dir}/config.ru":
        ensure  => file,
        owner   => $foreman_user,
        source  => "file:///${foreman_dir}/vendor/rails/railties/dispatches/config.ru",
      }
    }
  }

}
