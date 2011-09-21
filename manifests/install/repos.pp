class foreman::install::repos {
  case $operatingsystem {
    redhat,centos,fedora: {
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
    default: { fail("${hostname}: This module does not support operatingsystem $operatingsystem") }
  }
}
