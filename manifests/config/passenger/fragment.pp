# Define to create an Apache fragment.
#
# **Deprecated** Replaced by foreman::config::apache::fragment
#
# @param content
#   The content for the HTTP vhost
#
# @param ssl_content
#   The content for the HTTPS vhost
define foreman::config::passenger::fragment(
  $content=undef,
  $ssl_content=undef,
) {
  deprecation('foreman::config::passenger::fragment', 'Deprecated: use foreman::config::apache::fragment instead')

  foreman::config::apache::fragment { $title:
    content     => $content,
    ssl_content => $ssl_content,
  }
}
