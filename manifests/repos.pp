# @summary Set up a repository for foreman
# @api private
define foreman::repos(
  Variant[Enum['nightly'], Pattern['^\d+\.\d+$']] $repo,
  Boolean $gpgcheck = true,
) {
  case $facts['os']['family'] {
    'RedHat', 'Linux': {
      $yumcode = $facts['os']['name'] ? {
        'Amazon' => 'el7',
        'Fedora' => "f${facts['os']['release']['major']}",
        default  => "el${facts['os']['release']['major']}",
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
      fail("${facts['networking']['hostname']}: This module does not support osfamily ${facts['os']['family']}")
    }
  }
}
