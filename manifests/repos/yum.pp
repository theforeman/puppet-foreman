# Install a yum repo
define foreman::repos::yum (
  Variant[Enum['nightly'], Pattern['^\d+\.\d+$']] $repo,
  String $yumcode,
  Boolean $gpgcheck,
) {
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
    baseurl  => "https://yum.theforeman.org/releases/${repo}/${yumcode}/\$basearch",
    gpgcheck => $gpgcheck_enabled,
    gpgkey   => "https://yum.theforeman.org/releases/${repo}/RPM-GPG-KEY-foreman",
    enabled  => '1',
  }
  yumrepo { "${name}-source":
    descr    => "Foreman ${repo} - source",
    baseurl  => "https://yum.theforeman.org/releases/${repo}/${yumcode}/source",
    gpgcheck => $gpgcheck_enabled,
    gpgkey   => "https://yum.theforeman.org/releases/${repo}/RPM-GPG-KEY-foreman",
    enabled  => '0',
  }
  yumrepo { "${name}-plugins":
    descr    => "Foreman plugins ${repo}",
    baseurl  => "https://yum.theforeman.org/plugins/${repo}/${yumcode}/\$basearch",
    gpgcheck => '0',
    enabled  => '1',
  }
  yumrepo { "${name}-plugins-source":
    descr    => "Foreman plugins ${repo} - source",
    baseurl  => "https://yum.theforeman.org/plugins/${repo}/${yumcode}/source",
    gpgcheck => '0',
    enabled  => '0',
  }
  yumrepo { "${name}-rails":
    descr    => "Rails SCL for Foreman ${repo}",
    baseurl  => "https://yum.theforeman.org/rails/foreman-${repo}/${yumcode}/\$basearch",
    gpgcheck => $gpgcheck_enabled,
    enabled  => '1',
    gpgkey   => "https://yum.theforeman.org/rails/foreman-${repo}/RPM-GPG-KEY-copr",
  }
}
