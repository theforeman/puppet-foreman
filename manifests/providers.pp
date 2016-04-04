# = foreman_* providers support
#
# Installs dependencies to use the foreman_* types and providers.
#
# Default parameters should point to the latest packages required for
# the current version of the providers.
#
# === Parameters:
#
# $apipie_bindings::          Install apipie-bindings dependency
#                             type:boolean
#
# $apipie_bindings_package::  Name of apipie-bindings package
#
# $foreman_api::              Install foreman_api dependency (deprecated)
#                             type:boolean
#
# $foreman_api_package::      Name of foreman_api package
#
class foreman::providers(
  $apipie_bindings         = $::foreman::providers::params::apipie_bindings,
  $apipie_bindings_package = $::foreman::providers::params::apipie_bindings_package,
  $foreman_api             = $::foreman::providers::params::foreman_api,
  $foreman_api_package     = $::foreman::providers::params::foreman_api_package,
) inherits foreman::providers::params {
  validate_bool($apipie_bindings, $foreman_api)
  validate_string($apipie_bindings_package, $foreman_api_package)

  if $apipie_bindings {
    package { $apipie_bindings_package:
      ensure => installed,
    }
  }

  if $foreman_api {
    warning('Using foreman_api providers is deprecated, use rest_v2 with apipie-bindings instead')
    package { $foreman_api_package:
      ensure => installed,
    }
  }
}
