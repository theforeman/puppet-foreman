# Provides the ability to specify fragments for the ssl and non-ssl virtual
# hosts defined by foreman
#
# @param content
#   Content of the non-ssl virtual host fragment
# @param ssl_content
#   Content of the ssl virtual host fragment
define foreman::config::apache::fragment(
  $content=undef,
  $ssl_content=undef,
) {
  require ::foreman::config::apache

  $_priority = $foreman::config::apache::priority

  $http_path = "${::apache::confd_dir}/${_priority}-foreman.d/${name}.conf"
  $https_path = "${::apache::confd_dir}/${_priority}-foreman-ssl.d/${name}.conf"

  if $content and $content != '' {
    file { $http_path:
      ensure  => file,
      content => $content,
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
    }
  } else {
    file { $http_path:
      ensure => absent,
    }
  }

  if $ssl_content and $ssl_content != '' and $::foreman::config::apache::ssl {
    file { $https_path:
      ensure  => file,
      content => $ssl_content,
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
    }
  } else {
    file { $https_path:
      ensure => absent,
    }
  }

  File[$http_path, $https_path] ~> Class['apache::service']
}
