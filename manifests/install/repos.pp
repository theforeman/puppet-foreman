class foreman::install::repos {
  case $::operatingsystem {
    redhat,centos,fedora,Scientific: {
      $repo_testing_enabled = $foreman::params::use_testing ? {
        true    => '1',
        default => '0',
      }
      yumrepo {
        'foreman':
          descr    => 'Foreman stable repository',
          baseurl  => 'http://yum.theforeman.org/stable',
          gpgcheck => '0',
          enabled  => '1';
        'foreman-testing':
          descr    => 'Foreman testing repository',
          baseurl  => 'http://yum.theforeman.org/test',
          enabled  => $repo_testing_enabled,
          gpgcheck => '0',
      }
    }
    Debian,Ubuntu: {
      file { '/etc/apt/sources.list.d/foreman.list':
        content => "deb http://deb.theforeman.org/ stable main
        "
      }
      ~>
      exec { 'foreman-key':
        command     => '/usr/bin/wget -q http://deb.theforeman.org/foreman.asc -O- | /usr/bin/apt-key add -',
        refreshonly => true
      }
      ~>
      exec { 'update-apt':
        command     => '/usr/bin/apt-get update',
        refreshonly => true
      }
    }
    default: { fail("${::hostname}: This module does not support operatingsystem ${::operatingsystem}") }
  }
}
