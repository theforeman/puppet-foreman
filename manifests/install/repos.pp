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

      apt::key{'2048R/E775FF07':
        source => 'http://deb.theforeman.org/foreman.asc',
      }

      apt::sources_list{'foreman':
        content => "deb http://deb.theforeman.org/ ${::lsbdistcodename} ${repo}",
        require => Apt::Key['2048R/E775FF07'],
      }

    }
    default: { fail("${::hostname}: This module does not support operatingsystem ${::operatingsystem}") }
  }
}
