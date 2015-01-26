# = Foreman OpenSCAP plugin
#
# This class installs OpenSCAP plugin
#
# === Parameters:
#
# $configure_openscap_repo::  Enable custom yum repo with packages needed for foreman_openscap,
#                             type:boolean
#
# $scap_client_module_dir::   if you set a directory here, installer will upload foreman_scap_client
#                             puppet module into this directory for you
#                             e.g. /etc/puppet/environments/production/modules
#
class foreman::plugin::openscap (
  $configure_openscap_repo = true,
  $scap_client_module_dir  = undef,
) {
  validate_bool($configure_openscap_repo)

  case $::osfamily {
    'RedHat': {

      if $configure_openscap_repo {
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

      foreman::plugin {'openscap': }

      if $scap_client_module_dir {
        file { "${scap_client_module_dir}/foreman_scap_client":
          ensure  => directory,
          source  => '/usr/share/foreman-installer/modules/foreman_scap_client',
          recurse => true,
        }
      }

    }
    default: {
      fail("Unsupported osfamily ${::osfamily}")
    }
  }
}
