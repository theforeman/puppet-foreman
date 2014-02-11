define foreman::plugin(
  $package = "${foreman::plugin_prefix}${title}"
) {
  package { $package:
    ensure  => installed,
    require => Class['foreman::config'],
    notify  => Class['foreman::service'],
  }
}
