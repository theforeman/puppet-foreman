# Configure thirdparty repos
class foreman::install::repos::extra(
  $configure_epel_repo = $foreman::configure_epel_repo,
  $configure_scl_repo  = $foreman::configure_scl_repo,
) {
  $osreleasemajor = regsubst($::operatingsystemrelease, '^(\d+)\..*$', '\1')

  if $::osfamily == 'RedHat' and $::operatingsystem != 'Fedora' and $configure_epel_repo {
    yumrepo { 'epel':
      descr      => "Extra Packages for Enterprise Linux ${osreleasemajor} - \$basearch",
      mirrorlist => "https://mirrors.fedoraproject.org/metalink?repo=epel-${osreleasemajor}&arch=\$basearch",
      baseurl    => "http://download.fedoraproject.org/pub/epel/${osreleasemajor}/\$basearch",
      enabled    => 1,
      gpgcheck   => 1,
      gpgkey     => 'https://fedoraproject.org/static/0608B895.txt',
    }
  }

  if $configure_scl_repo {
    case $::operatingsystem {
      CentOS: {
        package {'centos-release-SCL':
          ensure => installed,
        }
      }
      Scientific: {
        yumrepo { 'SCL':
          descr    => 'Scientific Linux Software Collections',
          baseurl  => "http://ftp.scientificlinux.org/linux/scientific/${osreleasemajor}/\$basearch/external_products/softwarecollections/",
          enabled  => 1,
          gpgcheck => 1,
        }
      }
      default: {}
    }
  }
}
