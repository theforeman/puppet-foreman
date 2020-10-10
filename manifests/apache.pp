# @summary The apache configuration for Foreman
# @api private
class foreman::apache {
  class { 'foreman::config::apache':
    app_root           => $foreman::app_root,
    priority           => $foreman::vhost_priority,
    servername         => $foreman::servername,
    serveraliases      => $foreman::serveraliases,
    server_port        => $foreman::server_port,
    server_ssl_port    => $foreman::server_ssl_port,
    proxy_backend      => "unix://${foreman::listen_socket}",
    ssl                => $foreman::ssl,
    ssl_ca             => $foreman::server_ssl_ca,
    ssl_chain          => $foreman::server_ssl_chain,
    ssl_cert           => $foreman::server_ssl_cert,
    ssl_certs_dir      => $foreman::server_ssl_certs_dir,
    ssl_key            => $foreman::server_ssl_key,
    ssl_crl            => $foreman::server_ssl_crl,
    ssl_protocol       => $foreman::server_ssl_protocol,
    ssl_verify_client  => $foreman::server_ssl_verify_client,
    user               => $foreman::user,
    foreman_url        => $foreman::foreman_url,
    ipa_authentication => $foreman::ipa_authentication,
    keycloak           => $foreman::keycloak,
    keycloak_app_name  => $foreman::keycloak_app_name,
    keycloak_realm     => $foreman::keycloak_realm,
  }

  contain foreman::config::apache

  if $foreman::ipa_authentication {
    if $facts['os']['selinux']['enabled'] {
      selboolean { ['allow_httpd_mod_auth_pam', 'httpd_dbus_sssd']:
        persistent => true,
        value      => 'on',
      }
    }

    if $foreman::ipa_manage_sssd {
      service { 'sssd':
        ensure  => running,
        enable  => true,
        require => Package['sssd-dbus'],
      }
    }

    file { "/etc/pam.d/${foreman::pam_service}":
      ensure  => file,
      owner   => root,
      group   => root,
      mode    => '0644',
      content => template('foreman/pam_service.erb'),
    }

    $http_keytab = pick($foreman::http_keytab, "${apache::conf_dir}/http.keytab")

    exec { 'ipa-getkeytab':
      command => "/bin/echo Get keytab \
        && KRB5CCNAME=KEYRING:session:get-http-service-keytab kinit -k \
        && KRB5CCNAME=KEYRING:session:get-http-service-keytab /usr/sbin/ipa-getkeytab -k ${http_keytab} -p HTTP/${facts['networking']['fqdn']} \
        && kdestroy -c KEYRING:session:get-http-service-keytab",
      creates => $http_keytab,
    }
    -> file { $http_keytab:
      ensure => file,
      owner  => $apache::user,
      mode   => '0600',
    }

    foreman::config::apache::fragment { 'intercept_form_submit':
      ssl_content => template('foreman/intercept_form_submit.conf.erb'),
    }

    foreman::config::apache::fragment { 'lookup_identity':
      ssl_content => template('foreman/lookup_identity.conf.erb'),
    }

    foreman::config::apache::fragment { 'auth_gssapi':
      ssl_content => template('foreman/auth_gssapi.conf.erb'),
    }
  }
}
