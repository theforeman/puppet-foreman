# Install an apt repo
define foreman::repos::apt (
  Variant[Enum['nightly'], Pattern['^\d+\.\d+$']] $repo,
  Variant[String, Hash] $key = 'AE0AF310E2EA96B6B6F4BD726F8600B9563278F6',
  Stdlib::Httpurl $location = 'https://deb.theforeman.org/',
) {
  include ::apt

  ::apt::source { $name:
    repos    => $repo,
    location => $location,
    key      => $key,
    include  => {
      src => false,
    },
  }

  ::apt::source { "${name}-plugins":
    release  => 'plugins',
    repos    => $repo,
    location => $location,
    key      => $key,
    include  => {
      src => false,
    },
  }
}
