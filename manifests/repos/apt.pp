# @summary Install an apt repo
# @api private
define foreman::repos::apt (
  Variant[Enum['nightly'], Pattern['^\d+\.\d+$']] $repo,
  String $key = 'AE0AF310E2EA96B6B6F4BD726F8600B9563278F6',
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
