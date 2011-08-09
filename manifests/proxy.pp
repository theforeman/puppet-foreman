class foreman::proxy {

  # default variables 
  $proxy_dir    = "/usr/share/foreman-proxy"
  $foreman_proxy_user = "foreman-proxy"

  include foreman::proxy::puppetca
  include foreman::proxy::puppetrun
  include foreman::proxy::tftp-deploy

  package {"foreman-proxy": ensure => installed}

  file{"/etc/foreman-proxy/settings.yml":
    source  => "puppet:///modules/foreman/etc/foreman-proxy/settings.yml",
    owner   => $foreman_proxy_user,
    group   => $foreman_proxy_user,
    mode    => 644,
    require => Package["foreman-proxy"],
    notify  => Service["foreman-proxy"],
  }
  service {"foreman-proxy": ensure => running}
}
