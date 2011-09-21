class foreman::install::repos::redhat {
  yumrepo {
    "foreman":
      descr    => "Foreman stable repository",
      baseurl  => "http://yum.theforeman.org/stable",
      gpgcheck => "0",
      enabled  => "1";
    "foreman-testing":
      descr    => "Foreman testing repository",
      baseurl  => "http://yum.theforeman.org/test",
      enabled  => $foreman::params::use_testing ? {
        true    => "1",
        default => "0",
      },
      gpgcheck => "0",
  }
}
