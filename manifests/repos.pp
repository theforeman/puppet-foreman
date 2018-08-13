# Set up a repository for foreman
define foreman::repos(
  Variant[Enum['nightly'], Pattern['^\d+\.\d+$']] $repo,
  Boolean $gpgcheck = true,
) {
  case $::osfamily {
    'RedHat', 'Linux': {
      $yumcode = $::operatingsystem ? {
        'Amazon' => 'el7',
        'Fedora' => "f${::operatingsystemmajrelease}",
        default  => "el${::operatingsystemmajrelease}",
      }

      foreman::repos::yum {$name:
        repo     => $repo,
        yumcode  => $yumcode,
        gpgcheck => $gpgcheck,
      }
    }
    'Debian': {
      foreman::repos::apt {$name:
        repo => $repo,
      }
    }
    default: {
      fail("${::hostname}: This module does not support osfamily ${::osfamily}")
    }
  }
}
