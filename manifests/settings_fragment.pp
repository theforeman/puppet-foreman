# @summary Add a fragment to settings.yaml
#
# This is a thin wrapper around concat::fragment to provide a stable API.
#
# @param content
#   The content to store
# @param order
#   The order of the fragment
#
# @see concat::fragment
define foreman::settings_fragment (
  Variant[String[1], Deferred] $content,
  String[2, 2] $order,
) {
  concat::fragment { "foreman_settings+${order}-${name}":
    target  => '/etc/foreman/settings.yaml',
    content => $content,
    order   => $order,
  }
}
