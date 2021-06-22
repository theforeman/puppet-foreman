# @summary Manages a plugin installation and optionally its configuration
#
# @param version
#   The version to ensure
#
# @param package
#   The package to manage
#
# @param config
#   Content of the configg
#
# @param config_file
#   The path to the config file. Only relevant if `config` is given.
#
# @param config_file_mode
#   The mode of the config file. Only relevant if `config` is given.
#
# @param config_file_owner
#   The owner of the config file. Only relevant if `config` is given.
#
# @param config_file_group
#   The mode of the config file. Only relevant if `config` is given.
define foreman::plugin(
  String[1] $version = $foreman::plugin_version,
  String[1] $package = "${foreman::plugin_prefix}${title}",
  Stdlib::Absolutepath $config_file = "${foreman::plugin_config_dir}/foreman_${title}.yaml",
  String[1] $config_file_owner = 'root',
  String[1] $config_file_group = $foreman::group,
  Stdlib::Filemode $config_file_mode = '0640',
  Optional[Variant[String, Sensitive[String]]] $config = undef,
) {
  # Debian gem2deb converts underscores to hyphens
  case $facts['os']['family'] {
    'Debian': {
      $real_package = regsubst($package,'_','-','G')
    }
    default: {
      $real_package = $package
    }
  }
  package { $real_package:
    ensure => $version,
  }
  ~> Foreman::Rake['apipie:cache:index', 'apipie_dsl:cache']

  if $config {
    file { $config_file:
      ensure  => file,
      owner   => $config_file_owner,
      group   => $config_file_group,
      mode    => $config_file_mode,
      content => $config,
      require => Package[$real_package],
    }
  }

  Foreman::Plugin[$name] -> Class['foreman::database']
  Foreman::Plugin[$name] ~> Class['foreman::service']
}
