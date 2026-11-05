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
    source_format => 'sources',
    repos         => [$repo],
    location      => [$location],
    keyring       => "/etc/apt/keyrings/${name}.asc",
    require       => Apt::Keyring["${name}.asc"],
  }

  apt::source { "${name}-plugins":
    source_format => 'sources',
    release       => ['plugins'],
    repos         => [$repo],
    location      => [$location],
    keyring       => "/etc/apt/keyrings/${name}.asc",
    require       => Apt::Keyring["${name}.asc"],
  }

  # Remove sources created by the previous sources.list format
  apt::setting { "list-${name}":
    ensure => absent,
  }

  apt::setting { "list-${name}-plugins":
    ensure => absent,
  }
}
