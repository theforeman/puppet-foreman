# @summary Global overrides on parameters that hardly ever change
#
# @param hammer_plugin_prefix
#   Hammer plugin package prefix based normally on platform
#
class foreman::cli::globals (
  Optional[String] $hammer_plugin_prefix = undef,
) {
}
