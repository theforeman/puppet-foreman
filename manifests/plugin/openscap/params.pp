# Default parameters for foreman::plugin::openscap
class foreman::plugin::openscap::params {
  $configure_openscap_repo = $::osfamily == 'RedHat'
}
