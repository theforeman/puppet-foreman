# @summary Install an apt repo
# @api private
define foreman::repos::apt (
  Variant[Enum['nightly'], Pattern['^\d+\.\d+$']] $repo,
  String $key = '5B7C3E5A735BCB4D615829DC0BDDA991FD7AAC8A',
  Stdlib::HTTPUrl $key_location = 'https://deb.theforeman.org/foreman.asc',
  Stdlib::HTTPUrl $location = 'https://deb.theforeman.org/',
) {
  include apt

  apt::key { $name:
    ensure => refreshed,
    id     => $key,
    source => $key_location,
  }

  apt::source { $name:
    repos    => $repo,
    location => $location,
    include  => {
      src => false,
    },
    require  => Apt::Key['foreman'],
  }

  apt::source { "${name}-plugins":
    release  => 'plugins',
    repos    => $repo,
    location => $location,
    include  => {
      src => false,
    },
    require  => Apt::Key['foreman'],
  }
}
