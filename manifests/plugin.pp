define foreman::plugin(
  $package = "${foreman::plugin_prefix}${title}"
) {
  package { $package:
    ensure => installed,
    notify => Class['foreman::service'],
  }
}
