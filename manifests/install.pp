# Install the needed packages for foreman
class foreman::install {
  if ! $foreman::custom_repo {
    foreman::install::repos { 'foreman':
      repo     => $foreman::repo,
      gpgcheck => $foreman::gpgcheck,
    }
  }

  $repo = $foreman::custom_repo ? {
    true    => [],
    default => Foreman::Install::Repos['foreman'],
  }

  $osreleasemajor = regsubst($::operatingsystemrelease, '^(\d+)\..*$', '\1')

  if $foreman::configure_epel_repo {
    yumrepo { 'epel':
      descr      => "Extra Packages for Enterprise Linux ${osreleasemajor} - \$basearch",
      mirrorlist => "https://mirrors.fedoraproject.org/metalink?repo=epel-${osreleasemajor}&arch=\$basearch",
      baseurl    => "http://download.fedoraproject.org/pub/epel/${osreleasemajor}/\$basearch",
      enabled    => 1,
      gpgcheck   => 1,
      gpgkey     => 'https://fedoraproject.org/static/0608B895.txt',
    }
  }

  if $foreman::configure_scl_repo {
    case $::operatingsystem {
      CentOS: {
        yumrepo { 'SCL':
          descr    => "CentOS Software Collections",
          baseurl  => "http://dev.centos.org/centos/${osreleasemajor}/SCL/\$basearch",
          enabled  => 1,
          gpgcheck => 1,
          gpgkey   => 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-Testing-6',
        }
      }
      Scientific: {
        yumrepo { 'SCL':
          descr    => "Scientific Linux Software Collections",
          baseurl  => "http://ftp.scientificlinux.org/linux/scientific/${osreleasemajor}/\$basearch/external_products/softwarecollections/",
          enabled  => 1,
          gpgcheck => 1,
        }
      }
      default: {}
    }
  }

  case $foreman::db_type {
    sqlite: {
      case $::operatingsystem {
        Debian,Ubuntu: { $package = 'foreman-sqlite3' }
        default:       { $package = 'foreman-sqlite' }
      }
    }
    postgresql: {
      $package = 'foreman-postgresql'
    }
    mysql: {
      $package = 'foreman-mysql2'
    }
  }

  package { $package:
    ensure  => $foreman::version,
    require => $repo,
  }

  if $foreman::selinux or (str2bool($::selinux) and $foreman::selinux != false) {
    package { 'foreman-selinux':
      ensure  => $foreman::version,
      require => $repo,
    }
  }
}
