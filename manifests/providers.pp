# = foreman_* providers support
#
# Installs dependencies to use the foreman_* types and providers.
#
# Default parameters should point to the latest packages required for
# the current version of the providers.
#
# === Parameters:
#
# $oauth::                    Install oauth dependency
#                             type:boolean
#
# $oauth_package::            Name of oauth package
#
# $json::                     Install json dependency, not required on Ruby 1.9 or higher
#                             type:boolean
#
# $json_package::             Name of json package
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
  $oauth                   = $::foreman::providers::params::oauth,
  $oauth_package           = $::foreman::providers::params::oauth_package,
  $json                    = $::foreman::providers::params::json,
  $json_package            = $::foreman::providers::params::json_package,
  $apipie_bindings         = $::foreman::providers::params::apipie_bindings,
  $apipie_bindings_package = $::foreman::providers::params::apipie_bindings_package,
  $foreman_api             = $::foreman::providers::params::foreman_api,
  $foreman_api_package     = $::foreman::providers::params::foreman_api_package,
) inherits foreman::providers::params {
  validate_bool($oauth, $json, $apipie_bindings, $foreman_api)
  validate_string($oauth_package, $json_package, $apipie_bindings_package, $foreman_api_package)

  if $oauth {
    ensure_packages([$oauth_package])
  }

  if $json {
    ensure_packages([$json_package])
  }

  if $apipie_bindings {
    ensure_packages([$apipie_bindings_package])
  }

  if $foreman_api {
    warning('Using foreman_api providers is deprecated, use rest_v2 with apipie-bindings instead')
    ensure_packages([$foreman_api_package])
  }
}
