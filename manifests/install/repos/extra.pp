# Configure thirdparty repos
class foreman::install::repos::extra(
  $configure_epel_repo = $foreman::configure_epel_repo,
  $configure_scl_repo  = $foreman::configure_scl_repo,
  $ipa_authentication  = $foreman::ipa_authentication,
  $configure_ipa_repo  = $foreman::configure_ipa_repo,
) {
  $osreleasemajor = regsubst($::operatingsystemrelease, '^(\d+)\..*$', '\1')

  if $::osfamily == 'RedHat' and $::operatingsystem != 'Fedora' and $configure_epel_repo {
    $epel_gpgcheck = $osreleasemajor ? {
      '7'     => 0,
      default => 1,
    }
    yumrepo { 'epel':
      descr      => "Extra Packages for Enterprise Linux ${osreleasemajor} - \$basearch",
      mirrorlist => "https://mirrors.fedoraproject.org/metalink?repo=epel-${osreleasemajor}&arch=\$basearch",
      baseurl    => "http://download.fedoraproject.org/pub/epel/${osreleasemajor}/\$basearch",
      enabled    => 1,
      gpgcheck   => $epel_gpgcheck,
      gpgkey     => 'https://fedoraproject.org/static/0608B895.txt',
    }
  }

  if $configure_scl_repo {
    case $::operatingsystem {
      'CentOS': {
        package {'centos-release-SCL':
          ensure => installed,
        }
      }
      'Scientific': {
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

  if $ipa_authentication and $configure_ipa_repo {
    yumrepo { 'adelton-identity':
      enabled  => 1,
      gpgcheck => 0,
      baseurl  => "http://copr-be.cloud.fedoraproject.org/results/adelton/identity_demo/epel-${osreleasemajor}-\$basearch/",
      before   => [ Package['mod_authnz_pam', 'mod_lookup_identity', 'mod_intercept_form_submit', 'sssd-dbus'] ],
    }
  }
}
