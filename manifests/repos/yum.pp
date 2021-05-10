# @summary Install a yum repo
# @api private
define foreman::repos::yum (
  Variant[Enum['nightly'], Pattern['^\d+\.\d+$']] $repo,
  String $yumcode,
  Boolean $gpgcheck,
  Stdlib::HTTPUrl $baseurl,
  Optional[String] $keypath = undef,
  Variant[Integer[0, 99], Enum['absent']] $priority = 'absent',
) {
  $_keypath = pick($keypath, "${baseurl}/releases/${repo}/RPM-GPG-KEY-foreman")
  $gpgcheck_enabled_default = $gpgcheck ? {
    false   => '0',
    default => '1',
  }
  $gpgcheck_enabled = $repo ? {
    'nightly' => '0',
    default   => $gpgcheck_enabled_default,
  }
  yumrepo { $name:
    descr    => "Foreman ${repo}",
    baseurl  => "${baseurl}/releases/${repo}/${yumcode}/\$basearch",
    gpgcheck => $gpgcheck_enabled,
    gpgkey   => $_keypath,
    enabled  => '1',
    priority => $priority,
  }
  yumrepo { "${name}-source":
    descr    => "Foreman ${repo} - source",
    baseurl  => "${baseurl}/releases/${repo}/${yumcode}/source",
    gpgcheck => $gpgcheck_enabled,
    gpgkey   => $_keypath,
    enabled  => '0',
    priority => $priority,
  }
  yumrepo { "${name}-plugins":
    descr    => "Foreman plugins ${repo}",
    baseurl  => "${baseurl}/plugins/${repo}/${yumcode}/\$basearch",
    gpgcheck => '0',
    enabled  => '1',
    priority => $priority,
  }
  yumrepo { "${name}-plugins-source":
    descr    => "Foreman plugins ${repo} - source",
    baseurl  => "${baseurl}/plugins/${repo}/${yumcode}/source",
    gpgcheck => '0',
    enabled  => '0',
    priority => $priority,
  }
  # Foreman 2.0 dropped the separate rails repository
  yumrepo { "${name}-rails":
    ensure => absent,
  }
}
