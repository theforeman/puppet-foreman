# Configure the foreman repo
#
# @param repo
#   The repository version to manage. This can be a specific version or nightly
#
# @param gpgcheck
#   Turn on/off gpg check in repo files (effective only on RedHat family systems)
#
# @param yum_repo_baseurl
#   The base URL for Yum repositories
class foreman::repo (
  Optional[Variant[Enum['nightly'], Pattern['^\d+\.\d+$']]] $repo = undef,
  Boolean $gpgcheck = true,
  Stdlib::HTTPUrl $yum_repo_baseurl = 'https://yum.theforeman.org',
) {
  if $repo {
    foreman::repos { 'foreman':
      repo             => $repo,
      gpgcheck         => $gpgcheck,
      yum_repo_baseurl => $yum_repo_baseurl,
      before           => Anchor['foreman::repo'],
    }

    if $facts['os']['family'] == 'RedHat' {
      package { 'foreman':
        ensure      => "el${facts['os']['release']['major']}",
        enable_only => true,
        provider    => 'dnfmodule',
        require     => Foreman::Repos['foreman'],
      }
    }
  }

  # An anchor is used because it can be collected
  anchor { 'foreman::repo': } # lint:ignore:anchor_resource
}
