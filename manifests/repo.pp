# Configure the foreman repo
#
# @param repo
#   The repository version to manage. This can be a specific version or nightly
#
# @param configure_scl_repo
#   If disabled the SCL repo will not be configured on Red Hat clone systems.
#   (Currently only installs repos for CentOS and Scientific)
#
# @param gpgcheck
#   Turn on/off gpg check in repo files (effective only on RedHat family systems)
#
# @param scl_repo_ensure
#   The ensure to set on the SCL repo package
#
# @param yum_repo_baseurl
#   The base URL for Yum repositories
class foreman::repo (
  Optional[Variant[Enum['nightly'], Pattern['^\d+\.\d+$']]] $repo = undef,
  Boolean $gpgcheck = true,
  Boolean $configure_scl_repo = $facts['os']['name'] == 'CentOS' and $facts['os']['release']['major'] == '7',
  String $scl_repo_ensure = 'installed',
  Stdlib::HTTPUrl $yum_repo_baseurl = 'https://yum.theforeman.org',
) {
  if $repo {
    foreman::repos { 'foreman':
      repo             => $repo,
      gpgcheck         => $gpgcheck,
      yum_repo_baseurl => $yum_repo_baseurl,
      before           => Anchor['foreman::repo'],
    }

    if $configure_scl_repo {
      Foreman::Repos['foreman'] -> Package['centos-release-scl-rh']
    }

    if $facts['os']['release']['major'] == '8' and ($repo == 'nightly' or versioncmp($repo, '3.2') >= 0) {
      package { 'foreman':
        ensure      => "el${facts['os']['release']['major']}",
        enable_only => true,
        provider    => 'dnfmodule',
        require     => Foreman::Repos['foreman'],
      }
    } elsif $facts['os']['release']['major'] == '8' and versioncmp($repo, '2.5') >= 0 {
      package { 'ruby':
        ensure      => '2.7',
        enable_only => true,
        provider    => 'dnfmodule',
      }
    }
  }

  if $configure_scl_repo {
    package { 'centos-release-scl-rh':
      ensure => $scl_repo_ensure,
      before => Anchor['foreman::repo'],
    }
  }

  # An anchor is used because it can be collected
  anchor { 'foreman::repo': } # lint:ignore:anchor_resource
}
