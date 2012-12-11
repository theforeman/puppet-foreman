define foreman::install::repos(
  $repo = stable
) {
  include foreman::params

  case $::operatingsystem {
    redhat,centos,fedora,Scientific: {
      $repo_path = $repo ? {
        'stable' => 'releases/latest',
        default  => $repo,
      }
      yumrepo { $name:
          descr    => "Foreman ${repo} repository",
          baseurl  => "http://yum.theforeman.org/${repo_path}/${foreman::params::yumcode}/\$basearch",
          gpgcheck => '0',
          enabled  => '1';
      }
    }
    Debian,Ubuntu: {
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
    default: { fail("${::hostname}: This module does not support operatingsystem ${::operatingsystem}") }
  }
}
