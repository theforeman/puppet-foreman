class foreman::plugin::openscap::repo {
  case $::osfamily {
    'RedHat': {

      $repo = $::operatingsystem ? {
        'Fedora' => 'fedora',
        default  => 'epel',
      }

      if $::operatingsystemmajrelease == undef {
        $versions_array = split($::operatingsystemrelease, '\.') # facter 1.6
        $major = $versions_array[0]
      } else {
        $major = $::operatingsystemmajrelease # facter 1.7+
      }

      yumrepo { 'isimluk-openscap':
        enabled  => 1,
        gpgcheck => 0,
        baseurl  => "http://copr-be.cloud.fedoraproject.org/results/isimluk/OpenSCAP/${repo}-${major}-\$basearch/",
        before   => [ Foreman::Plugin['openscap'] ],
      }
    }
    default: {
      fail("Unsupported osfamily ${::osfamily}")
    }
  }
}
