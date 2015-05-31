# = Foreman OpenSCAP plugin
#
# This class installs OpenSCAP plugin
#
# === Parameters:
#
# $configure_openscap_repo::  Enable custom yum repo with packages needed for foreman_openscap,
#                             type:boolean
#
class foreman::plugin::openscap (
  $configure_openscap_repo = $foreman::plugin::openscap::params::configure_openscap_repo,
) inherits foreman::plugin::openscap::params {
  validate_bool($configure_openscap_repo)

  if $configure_openscap_repo {
    contain foreman::plugin::openscap::repo
  }

  foreman::plugin {'openscap': }
}
