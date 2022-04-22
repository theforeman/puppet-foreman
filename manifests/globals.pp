# @summary Global overrides on parameters that hardly ever change
#
# @param plugin_prefix
#   String which is prepended to the plugin package names.

# @param manage_user
#   Controls whether the Foreman module will manage the user on the system.
#
# @param user
#   User under which foreman will run.
#
# @param group
#   Primary group for the Foreman user.
#
# @param user_groups
#   Additional groups for the Foreman user.
#
# @param app_root
#   Path of Foreman root directory.
#
# @param rails_env
#   Rails environment of Foreman.
#
# @param vhost_priority
#   Defines Apache vhost priority for the Foreman vhost conf file.
#
# @param selinux_ignore_defaults
#   Do not lookup default security context for file resources in catalogue compilation and attempt to manage them; instead defer context lookups to the system itself when the files are actually created. Useful during initial installs, because Puppet can install packages which modify the security policy after the context lookups were performed, which breaks idempotence. This can be disabled after the initial install, to allow Puppet to remedy drift in security context.
class foreman::globals (
  Optional[String] $plugin_prefix = undef,
  Boolean $manage_user = true,
  String $user = 'foreman',
  String $group = 'foreman',
  Array[String] $user_groups = [],
  Stdlib::Absolutepath $app_root = '/usr/share/foreman',
  String[1] $rails_env = 'production',
  String[1] $vhost_priority = '05',
  Boolean $selinux_ignore_defaults = true,
) {
}
