class foreman::proxy::puppetrun {
  
  myline {
    "allow_foreman_proxy_to_execute_puppetrun":
      file => "/etc/sudoers",
      line => "${foreman_proxy_user} ALL = NOPASSWD: /usr/bin/puppetrun"
  }

}
