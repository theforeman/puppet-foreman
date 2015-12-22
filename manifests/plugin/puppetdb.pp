# = PuppetDB Foreman plugin
#
# Installs the puppetdb_foreman plugin
#
# === Parameters:
#
# $package:: Package name to install, use ruby193-rubygem-puppetdb_foreman on Foreman 1.8/1.9 on EL
#
# $address:: Address of puppetdb API. Defaults to 'https://localhost:8081/v2/commands'
#
# $dashboard_address:: Address of puppetdb dashboard. Defaults to 'http://localhost:8080/dashboard'
#
class foreman::plugin::puppetdb (
  $package           = $foreman::plugin::puppetdb::params::package,
  $address           = $foreman::plugin::puppetdb::params::address,
  $dashboard_address = $foreman::plugin::puppetdb::params::dashboard_address,
) inherits foreman::plugin::puppetdb::params {

  validate_string($package, $address, $dashboard_address)

  foreman::plugin { 'puppetdb':
    package => $package,
  }
  ->
  foreman_config_entry { 'puppetdb_enabled':
    value => true,
  }
  ->
  foreman_config_entry { 'puppetdb_address':
    value => $address,
  }
  ->
  foreman_config_entry { 'puppetdb_dashboard_address':
    value => $dashboard_address,
  }
}
