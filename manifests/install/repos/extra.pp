# Configure thirdparty repos
class foreman::install::repos::extra(
  $configure_epel_repo      = $::foreman::configure_epel_repo,
  $configure_scl_repo       = $::foreman::configure_scl_repo,
  $ipa_authentication       = $::foreman::ipa_authentication,
  $configure_brightbox_repo = $::foreman::configure_brightbox_repo,
) {
  $osreleasemajor = regsubst($::operatingsystemrelease, '^(\d+)\..*$', '\1')

  if $configure_epel_repo {
    $epel_gpgkey = $osreleasemajor ? {
      '7'     => 'https://fedoraproject.org/static/352C64E5.txt',
      default => 'https://fedoraproject.org/static/0608B895.txt',
    }
    yumrepo { 'epel':
      descr      => "Extra Packages for Enterprise Linux ${osreleasemajor} - \$basearch",
      mirrorlist => "https://mirrors.fedoraproject.org/metalink?repo=epel-${osreleasemajor}&arch=\$basearch",
      baseurl    => "http://download.fedoraproject.org/pub/epel/${osreleasemajor}/\$basearch",
      enabled    => 1,
      gpgcheck   => 1,
      gpgkey     => $epel_gpgkey,
    }
  }

  if $configure_scl_repo {
    package {'foreman-release-scl':
      ensure => installed,
    }
  }

  if $configure_brightbox_repo {
    include ::apt
    ::apt::ppa { 'ppa:brightbox/ruby-ng': }
    ::apt::ppa { 'ppa:brightbox/passenger-legacy': }

    # Setting alternatives to manual mode prevents the installation of 1.9 from later
    # automatically switching them
    alternatives { ['ruby', 'gem']:
      mode => 'manual',
    }
  }
}
