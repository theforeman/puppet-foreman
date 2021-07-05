# Configure foreman
class foreman::config {
  # Ensure 'puppet' user group is present before managing foreman user
  # Relationship is duplicated there as defined() is parse-order dependent
  if defined(Class['puppet::server::install']) {
    Class['puppet::server::install'] -> Class['foreman::config']
  }

  if $foreman::dynflow_manage_services {
    if $foreman::dynflow_redis_url != undef {
      $dynflow_redis_url = $foreman::dynflow_redis_url
    } else {
      include redis
      $dynflow_redis_url = "redis://localhost:${redis::port}/6"
    }

    file { '/etc/foreman/dynflow':
      ensure => directory,
    }
  }

  # Used in the settings template
  $websockets_ssl_cert = pick($foreman::websockets_ssl_cert, $foreman::server_ssl_cert)
  $websockets_ssl_key = pick($foreman::websockets_ssl_key, $foreman::server_ssl_key)

  concat::fragment {'foreman_settings+01-header.yaml':
    target  => '/etc/foreman/settings.yaml',
    content => template('foreman/settings.yaml.erb'),
    order   => '01',
  }

  concat {'/etc/foreman/settings.yaml':
    owner => 'root',
    group => $foreman::group,
    mode  => '0640',
  }

  $db_pool = max($foreman::db_pool, $foreman::foreman_service_puma_threads_max)

  file { '/etc/foreman/database.yml':
    owner   => 'root',
    group   => $foreman::group,
    mode    => '0640',
    content => template('foreman/database.yml.erb'),
  }

  systemd::dropin_file { 'foreman-service':
    filename => 'installer.conf',
    unit     => "${foreman::foreman_service}.service",
    content  => template('foreman/foreman.service-overrides.erb'),
  }

  file { $foreman::app_root:
    ensure  => directory,
  }

  if $foreman::db_root_cert {
    $pg_cert_dir = "${foreman::app_root}/.postgresql"

    file { $pg_cert_dir:
      ensure => 'directory',
      owner  => 'root',
      group  => $foreman::group,
      mode   => '0640',
    }

    file { "${pg_cert_dir}/root.crt":
      ensure => file,
      source => $foreman::db_root_cert,
      owner  => 'root',
      group  => $foreman::group,
      mode   => '0640',
    }
  }

  if $foreman::manage_user {
    if $foreman::puppet_ssldir in $foreman::server_ssl_key or $foreman::puppet_ssldir in $foreman::client_ssl_key {
      $_user_groups = $foreman::user_groups + ['puppet']
    } else {
      $_user_groups = $foreman::user_groups
    }

    group { $foreman::group:
      ensure => 'present',
    }
    user { $foreman::user:
      ensure  => 'present',
      shell   => '/bin/false',
      comment => 'Foreman',
      home    => $foreman::app_root,
      gid     => $foreman::group,
      groups  => unique($_user_groups),
    }
  }

  if $foreman::apache {
    $listen_socket = '/run/foreman.sock'

    class { 'foreman::config::apache':
      app_root           => $foreman::app_root,
      priority           => $foreman::vhost_priority,
      servername         => $foreman::servername,
      serveraliases      => $foreman::serveraliases,
      server_port        => $foreman::server_port,
      server_ssl_port    => $foreman::server_ssl_port,
      proxy_backend      => "unix://${listen_socket}",
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

    $foreman_socket_override = template('foreman/foreman.socket-overrides.erb')

    if $foreman::ipa_authentication {
      unless fact('foreman_ipa.default_server') {
        fail("${facts['networking']['hostname']}: The system does not seem to be IPA-enrolled")
      }

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

      exec { 'ipa-getkeytab':
        command => "/bin/echo Get keytab \
          && KRB5CCNAME=KEYRING:session:get-http-service-keytab kinit -k \
          && KRB5CCNAME=KEYRING:session:get-http-service-keytab /usr/sbin/ipa-getkeytab -s ${facts['foreman_ipa']['default_server']} -k ${foreman::http_keytab} -p HTTP/${facts['networking']['fqdn']} \
          && kdestroy -c KEYRING:session:get-http-service-keytab",
        creates => $foreman::http_keytab,
      }
      -> file { $foreman::http_keytab:
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


      if $foreman::ipa_manage_sssd {
        $sssd = $facts['foreman_sssd']
        $sssd_services = join(unique(pick($sssd['services'], []) + ['ifp']), ', ')
        $sssd_ldap_user_extra_attrs = join(unique(pick($sssd['ldap_user_extra_attrs'], []) + ['email:mail', 'lastname:sn', 'firstname:givenname']), ', ')
        $sssd_allowed_uids = join(unique(pick($sssd['allowed_uids'], []) + ['apache', 'root']), ', ')
        $sssd_user_attributes = join(unique(pick($sssd['user_attributes'], []) + ['+email', '+firstname', '+lastname']), ', ')

        augeas { 'sssd-ifp-extra-attributes':
          context => '/files/etc/sssd/sssd.conf',
          changes => [
            "set target[.=~regexp('domain/.*')]/ldap_user_extra_attrs '${sssd_ldap_user_extra_attrs}'",
            "set target[.='sssd']/services '${sssd_services}'",
            'set target[.=\'ifp\'] \'ifp\'',
            "set target[.='ifp']/allowed_uids '${sssd_allowed_uids}'",
            "set target[.='ifp']/user_attributes '${sssd_user_attributes}'",
          ],
          notify  => Service['sssd'],
        }
      }

      concat::fragment {'foreman_settings+02-authorize_login_delegation.yaml':
        target  => '/etc/foreman/settings.yaml',
        content => template('foreman/settings-external-auth.yaml.erb'),
        order   => '02',
      }
    }
  } else {
    $foreman_socket_override = undef
  }

  systemd::dropin_file { 'foreman-socket':
    ensure   => bool2str($foreman_socket_override =~ Undef, 'absent', 'present'),
    filename => 'installer.conf',
    unit     => "${foreman::foreman_service}.socket",
    content  => $foreman_socket_override,
  }
}
