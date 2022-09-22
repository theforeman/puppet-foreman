# @summary Set up a repository for foreman
# @api private
define foreman::repos (
  Stdlib::HTTPUrl $yum_repo_baseurl,
  Variant[Enum['nightly'], Pattern['^\d+\.\d+$']] $repo,
  Boolean $gpgcheck = true,
) {
  case $facts['os']['family'] {
    'RedHat': {
      foreman::repos::yum { $name:
        repo     => $repo,
        yumcode  => "el${facts['os']['release']['major']}",
        gpgcheck => $gpgcheck,
        baseurl  => $yum_repo_baseurl,
      }
    }
    'Debian': {
      foreman::repos::apt { $name:
        repo => $repo,
      }
    }
    default: {
      fail("${facts['networking']['hostname']}: This module does not support osfamily ${facts['os']['family']}")
    }
  }
}
