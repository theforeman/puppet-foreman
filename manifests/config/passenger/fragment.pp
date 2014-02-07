# provides the ability to specify fragments for the ssl and non-ssl
#   virtual hosts defined by foreman
#
#  === Parameters:
#
#  $content::  content of the non-ssl virtual host fragment
#  $ssl_content:: content of the ssl virtual host fragment
#
define foreman::config::passenger::fragment(
  $content='',
  $ssl_content='',
) {
  require foreman::config::passenger

  file { "${apache::confd_dir}/05-foreman.d/${name}.conf":
    ensure  => present,
    content => $content,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    notify  => Class['apache::service'],
  }

  if $::foreman::config::passenger::ssl {
    file { "${apache::confd_dir}/05-foreman-ssl.d/${name}.conf":
      ensure  => present,
      content => $ssl_content,
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      notify  => Class['apache::service'],
    }
  }
}
