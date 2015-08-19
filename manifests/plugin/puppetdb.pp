# = PuppetDB Foreman plugin
#
# Installs the puppetdb_foreman plugin
#
# === Parameters:
#
# $package:: Package name to install, use ruby193-rubygem-puppetdb_foreman on Foreman 1.8/1.9 on EL
#
class foreman::plugin::puppetdb(
  $package = $foreman::plugin::puppetdb::params::package,
) inherits foreman::plugin::puppetdb::params {
  foreman::plugin {'puppetdb':
    package => $package,
  }
}
