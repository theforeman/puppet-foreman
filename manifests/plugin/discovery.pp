# = Foreman Discovery plugin
#
# This class installs discovery plugin and images
#
# === Parameters:
#
# $version::         version string of discovery image, in form of x.y.z-r
#
# $source::          mirror url from which the image files should be obtained, you
#                    can use http(s):// or file://
#
# $initrd::          name of initrd image file
#
# $kernel::          name of kernel file
#
# $install_images::  should the installer download and setup discovery images
#                    for you? the average size is few hundreds of MB
#                    type:boolean
#
class foreman::plugin::discovery (
  $version        = $foreman::plugin::discovery::params::version,
  $source         = $foreman::plugin::discovery::params::source,
  $initrd         = $foreman::plugin::discovery::params::initrd,
  $kernel         = $foreman::plugin::discovery::params::kernel,
  $install_images = $foreman::plugin::discovery::params::install_images,
) inherits foreman::plugin::discovery::params {

  validate_bool($install_images)

  foreman::plugin {'discovery':
  }

  if $install_images {
    include ::tftp::params

    foreman::remote_file {"${::tftp::params::root}boot/${kernel}":
      remote_location => "${source}${kernel}",
      mode            => 0644,
      require         => File["${::tftp::params::root}boot"],
    }
    foreman::remote_file {"${::tftp::params::root}boot/${initrd}":
      remote_location => "${source}${initrd}",
      mode            => 0644,
      require         => File["${::tftp::params::root}boot"],
    }
  }
}
