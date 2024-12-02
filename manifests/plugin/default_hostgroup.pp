# @summary This class installs the default_hostgroup plugin and optionally manages the configuration file
#
# @param hostgroups An array of hashes of hostgroup names and facts to add to the configuration
# @param ensure Specify the package state, or absent/purged to remove it
#
class foreman::plugin::default_hostgroup (
  Optional[String[1]] $ensure = undef,
  Array[Hash[String, Hash]] $hostgroups = [],
) {
  if empty($hostgroups) {
    $config = undef
  } else {
    $config = template('foreman/default_hostgroup.yaml.erb')
  }

  foreman::plugin { 'default_hostgroup':
    version     => $ensure,
    config      => $config,
    config_file => "${foreman::plugin_config_dir}/default_hostgroup.yaml",
  }
}
