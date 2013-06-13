# Set up a repository for foreman
define foreman::install::repos(
  $repo = stable,
  $gpgcheck = true
) {
  include foreman::params

  case $::osfamily {
    RedHat: {
      $repo_path = $repo ? {
        'stable' => 'releases/latest',
        default  => $repo,
      }
      $gpgcheck_enabled_default = $gpgcheck ? {
        false   => '0',
        default => '1',
      }
      $gpgcheck_enabled = $repo ? {
        'nightly' => '0',
        default   => $gpgcheck_enabled_default,
      }
      yumrepo { $name:
          descr    => "Foreman ${repo} repository",
          baseurl  => "http://yum.theforeman.org/${repo_path}/${foreman::params::yumcode}/\$basearch",
          gpgcheck => $gpgcheck_enabled,
          gpgkey   => 'http://yum.theforeman.org/RPM-GPG-KEY-foreman',
          enabled  => '1',
      }
      yumrepo { "${name}-source":
          descr    => "Foreman ${repo} source repository",
          baseurl  => "http://yum.theforeman.org/${repo_path}/${foreman::params::yumcode}/source",
          gpgcheck => $gpgcheck_enabled,
          gpgkey   => 'http://yum.theforeman.org/RPM-GPG-KEY-foreman',
          enabled  => '0',
      }
    }
    Debian: {
      file { "/etc/apt/sources.list.d/${name}.list":
        content => "deb http://deb.theforeman.org/ ${::lsbdistcodename} ${repo}\n"
      }
      ~>
      exec { "foreman-key-${name}":
        command     => '/usr/bin/wget -q http://deb.theforeman.org/foreman.asc -O- | /usr/bin/apt-key add -',
        refreshonly => true
      }
      ~>
      exec { "update-apt-${name}":
        command     => '/usr/bin/apt-get update',
        refreshonly => true
      }
    }
    default: { fail("${::hostname}: This module does not support operatingsystem ${::osfamily}") }
  }
}
