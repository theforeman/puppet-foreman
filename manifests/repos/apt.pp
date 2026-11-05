# @summary Install an apt repo
# @api private
define foreman::repos::apt (
  Variant[Enum['nightly'], Pattern['^\d+\.\d+$']] $repo,
  Stdlib::HTTPUrl $key_location = 'https://deb.theforeman.org/foreman.asc',
  Stdlib::HTTPUrl $location = 'https://deb.theforeman.org/',
) {
  include apt

  apt::keyring { "${name}.asc":
    source => $key_location,
  }

  apt::source { $name:
    repos    => $repo,
    location => $location,
    include  => {
      src => false,
    },
    keyring  => "/etc/apt/keyrings/${name}.asc",
    require  => Apt::Keyring["${name}.asc"],
  }

  apt::source { "${name}-plugins":
    release  => 'plugins',
    repos    => $repo,
    location => $location,
    include  => {
      src => false,
    },
    keyring  => "/etc/apt/keyrings/${name}.asc",
    require  => Apt::Keyring["${name}.asc"],
  }
}
