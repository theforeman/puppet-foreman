# = Default Hostgroup plugin
#
# This class installs the default_hostgroup plugin and optionally manages the configuration file
#
# === Parameters:
#
# $hostgroups::   An array of hashes of hostgroup names and facts to add to the configuration
#
class foreman::plugin::default_hostgroup (
  Array[Hash[String, Hash]] $hostgroups = [],
){
  if empty($hostgroups) {
    $config = undef
  } else {
    $config = template('foreman/default_hostgroup.yaml.erb')
  }

  foreman::plugin {'default_hostgroup':
    config      => $config,
    config_file => "${foreman::plugin_config_dir}/default_hostgroup.yaml",
  }
}
