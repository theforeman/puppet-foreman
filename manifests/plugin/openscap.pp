# = Foreman OpenSCAP plugin
#
# This class installs OpenSCAP plugin
#
# === Parameters:
#
# $configure_openscap_repo::  Enable custom yum repo with packages needed for foreman_openscap,
#                             type:boolean
#
class foreman::plugin::openscap (
  $configure_openscap_repo = $foreman::plugin::openscap::params::configure_openscap_repo,
) inherits foreman::plugin::openscap::params {
  validate_bool($configure_openscap_repo)

  if $configure_openscap_repo {
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

  foreman::plugin {'openscap': }
}
