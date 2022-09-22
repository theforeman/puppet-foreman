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
class foreman::providers (
  Boolean $oauth = true,
  String $oauth_package = $foreman::providers::params::oauth_package,
) inherits foreman::providers::params {
  if $oauth {
    ensure_packages([$oauth_package])
    anchor { 'foreman::providers::oauth': } # lint:ignore:anchor_resource
    Anchor <| title == 'foreman::repo' |> -> Package[$oauth_package] -> Anchor['foreman::providers::oauth']
  }
}
