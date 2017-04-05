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
#
# $oauth_package::            Name of oauth package
#
# $json::                     Install json dependency, not required on Ruby 1.9 or higher
#
# $json_package::             Name of json package
#
# $apipie_bindings::          Install apipie-bindings dependency
#
# $apipie_bindings_package::  Name of apipie-bindings package
#
class foreman::providers(
  Boolean $oauth = $::foreman::providers::params::oauth,
  String $oauth_package = $::foreman::providers::params::oauth_package,
  Boolean $json = $::foreman::providers::params::json,
  String $json_package = $::foreman::providers::params::json_package,
  Boolean $apipie_bindings = $::foreman::providers::params::apipie_bindings,
  String $apipie_bindings_package = $::foreman::providers::params::apipie_bindings_package,
) inherits foreman::providers::params {
  if $oauth {
    ensure_packages([$oauth_package])
  }

  if $json {
    ensure_packages([$json_package])
  }

  if $apipie_bindings {
    ensure_packages([$apipie_bindings_package])
  }
}
