class foreman::proxy::puppetca {

  file{"/etc/puppet/autosign.conf":
    owner => $foreman_proxy_user, 
    group => "puppet",
    mode  => 644,
    require => Package["foreman-proxy"],
  }

  myline {
    "allow_foreman_proxy_to_execute_puppetca":
      file => "/etc/sudoers",
      line => "${foreman_proxy_user} ALL = NOPASSWD: /usr/sbin/puppetca";
    "foreman_proxy_user_does_not_require_tty_in_sudo":
      file    => "/etc/sudoers",
      line    => "Defaults:${foreman_proxy_user} !requiretty";
  }

}
