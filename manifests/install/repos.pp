define foreman::install::repos(
  $use_testing    = false,
) {
  case $::operatingsystem {
    redhat,centos,fedora,Scientific: {
      $repo_testing_enabled = $use_testing ? {
        true    => '1',
        default => '0',
      }
      yumrepo {
        "$name":
          descr    => 'Foreman stable repository',
          baseurl  => $foreman::params::yumrepo,
          gpgcheck => '0',
          enabled  => '1';
        "$name-testing":
          descr    => 'Foreman testing repository',
          baseurl  => 'http://yum.theforeman.org/test',
          enabled  => $repo_testing_enabled,
          gpgcheck => '0',
      }
    }
    Debian,Ubuntu: {
      $component_name = $use_testing ? {
        true    => 'nightly',
        default => 'stable',
      }
      file { "/etc/apt/sources.list.d/$name.list":
        content => "deb http://deb.theforeman.org/ $lsbdistcodename $component_name\n"
      }
      ~>
      exec { "foreman-key-$name":
        command     => '/usr/bin/wget -q http://deb.theforeman.org/foreman.asc -O- | /usr/bin/apt-key add -',
        refreshonly => true
      }
      ~>
      exec { "update-apt-$name":
        command     => '/usr/bin/apt-get update',
        refreshonly => true
      }
    }
    default: { fail("${::hostname}: This module does not support operatingsystem ${::operatingsystem}") }
  }
}
