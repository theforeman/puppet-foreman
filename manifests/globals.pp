# @summary Global overrides on parameters that hardly ever change
#
# @param plugin_prefix
#   String which is prepended to the plugin package names
#
class foreman::globals (
  Optional[String] $plugin_prefix = undef,
) {
}
