# Install the needed packages for foreman
class foreman::install {
  if ! $foreman::custom_repo {
    foreman::install::repos { 'foreman':
      repo     => $foreman::repo,
      gpgcheck => $foreman::gpgcheck,
    }
  }

  class { '::foreman::install::repos::extra': }

  $repo = $foreman::custom_repo ? {
    true    => Class['foreman::install::repos::extra'],
    default => [Class['foreman::install::repos::extra'], Foreman::Install::Repos['foreman']],
  }

  case $foreman::db_type {
    'sqlite': {
      case $::operatingsystem {
        'Debian','Ubuntu': { $package = 'foreman-sqlite3' }
        default:           { $package = 'foreman-sqlite' }
      }
    }
    'postgresql': {
      $package = 'foreman-postgresql'
    }
    'mysql': {
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
    if $foreman::ipa_authentication and $foreman::configure_ipa_repo and $foreman::osreleasemajor == '6' {
      package { 'mod_lookup_identity-selinux':
        ensure  => installed,
        require => $repo,
      }
    }
  }

  if $::foreman::passenger_ruby_package {
    package { $::foreman::passenger_ruby_package:
      ensure  => installed,
      require => Class['apache'],
      before  => Class['apache::service'],
    }
  }

  if $foreman::ipa_authentication {
    case $::osfamily {
      'RedHat': {
        # The apache::mod's need to be in install to break circular dependencies
        ::apache::mod { 'authnz_pam': package => 'mod_authnz_pam' }
        ::apache::mod { 'intercept_form_submit': package => 'mod_intercept_form_submit' }
        ::apache::mod { 'lookup_identity': package => 'mod_lookup_identity' }
        include ::apache::mod::auth_kerb
      }
      default: {
        fail("${::hostname}: ipa_authentication is not supported on osfamily ${::osfamily}")
      }
    }

    if $foreman::ipa_manage_sssd {
      package { 'sssd-dbus':
        ensure => installed,
      }
    }
  }
}
