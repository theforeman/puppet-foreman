# @summary Configure thirdparty repos
# @api private
class foreman::repos::extra(
  Boolean $configure_epel_repo = $foreman::configure_epel_repo,
  Boolean $configure_scl_repo = $foreman::configure_scl_repo,
  String $scl_repo_ensure = 'installed',
) {
  if $configure_epel_repo {
    yumrepo { 'epel':
      descr      => "Extra Packages for Enterprise Linux ${facts['os']['release']['major']} - \$basearch",
      mirrorlist => "https://mirrors.fedoraproject.org/metalink?repo=epel-${facts['os']['release']['major']}&arch=\$basearch",
      baseurl    => "http://download.fedoraproject.org/pub/epel/${facts['os']['release']['major']}/\$basearch",
      enabled    => 1,
      gpgcheck   => 1,
      gpgkey     => 'https://fedoraproject.org/static/352C64E5.txt',
    }
  }

  if $configure_scl_repo {
    package {'foreman-release-scl':
      ensure => $scl_repo_ensure,
    }
  }
}
