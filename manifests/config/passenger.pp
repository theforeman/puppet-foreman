# Configure the foreman service using passenger
#
# === Parameters:
#
# $app_root::               Root of the application.
#
# $listen_on_interface::    Specify which interface to bind passenger to.
#                           Defaults to all interfaces.
#
# $scl_prefix::             RedHat SCL prefix.
#
# $servername::             Servername for the vhost.
#
# $ssl::                    Whether to enable SSL.
#
# $ssl_cert::               Location of the SSL certificate file.
#
# $ssl_key::                Location of the SSL key file.
#
# $ssl_ca::                 Location of the SSL CA file
#
# $use_vhost::              Whether to install a vhost. Note that using ssl and
#                           no vhost is unsupported.
#
# $user::                   The user under which the application runs.
#
class foreman::config::passenger(
  $app_root            = $foreman::app_root,
  $listen_on_interface = $foreman::passenger_interface,
  $scl_prefix          = $foreman::passenger_scl,
  $servername          = $::fqdn,
  $ssl                 = $foreman::ssl,
  $ssl_ca              = $foreman::server_ssl_ca,
  $ssl_chain           = $foreman::server_ssl_chain,
  $ssl_cert            = $foreman::server_ssl_cert,
  $ssl_key             = $foreman::server_ssl_key,
  $use_vhost           = $foreman::use_vhost,
  $user                = $foreman::user
) {
  # validate parameter values
  validate_string($listen_on_interface)
  validate_bool($ssl)

  $docroot = "${app_root}/public"

  include ::apache
  include ::apache::mod::headers
  include ::apache::mod::passenger

  if $::osfamily == 'RedHat' {
    # Work around https://github.com/puppetlabs/puppetlabs-apache/pull/563
    File <| title == 'passenger.conf' |> {
      replace => false,
    }
    Apache::Mod['passenger'] -> File['passenger.conf']
  }

  # Ensure the Version module is loaded as we need it in the Foreman vhosts
  # RedHat distros come with this enabled. Newer Debian and Ubuntu distros
  # comes also with this enabled. Only old Debian and Ubuntu distros (squeeze,
  # lucid, precise) needs hand-holding.
  case $::lsbdistcodename {
    'squeeze','lucid','precise': {
      ::apache::mod { 'version': }
    }
    default: {}
  }

  if $use_vhost {
    # Workaround so apache::vhost doesn't attempt to create a directory
    file { $docroot: }

    # Check the value in case the interface doesn't exist, otherwise listen on all interfaces
    if $listen_on_interface and $listen_on_interface in split($::interfaces, ',') {
      $listen_interface = inline_template("<%= @ipaddress_${listen_on_interface} %>")
    } else {
      $listen_interface = undef
    }

    file { "${apache::confd_dir}/05-foreman.d":
      ensure => 'directory',
      owner  => 'root',
      group  => 'root',
      mode   => '0644',
    }

    apache::vhost { 'foreman':
      servername      => $servername,
      serveraliases   => ['foreman'],
      ip              => $listen_interface,
      port            => 80,
      docroot         => $docroot,
      priority        => '05',
      options         => ['SymLinksIfOwnerMatch'],
      custom_fragment => template('foreman/apache-fragment.conf.erb', 'foreman/_assets.conf.erb',
                                  'foreman/_virt_host_include.erb'),
    }

    if $ssl {

      file { "${apache::confd_dir}/05-foreman-ssl.d":
        ensure => 'directory',
        owner  => 'root',
        group  => 'root',
        mode   => '0644',
      }

      apache::vhost { 'foreman-ssl':
        servername        => $servername,
        serveraliases     => ['foreman'],
        ip                => $listen_interface,
        port              => 443,
        docroot           => $docroot,
        priority          => '05',
        options           => ['SymLinksIfOwnerMatch'],
        ssl               => true,
        ssl_cert          => $ssl_cert,
        ssl_key           => $ssl_key,
        ssl_chain         => $ssl_chain,
        ssl_ca            => $ssl_ca,
        ssl_verify_client => 'optional',
        ssl_options       => '+StdEnvVars',
        ssl_verify_depth  => '3',
        custom_fragment   => template('foreman/apache-fragment.conf.erb', 'foreman/_assets.conf.erb',
                                      'foreman/_ssl_virt_host_include.erb'),
      }
    }
  } else {
    file { 'foreman_vhost':
      path    => "${apache::params::conf_dir}/foreman.conf",
      content => template('foreman/foreman-apache.conf.erb'),
      mode    => '0644',
    }

    if $ssl {
      fail('Use of ssl = true and use_vhost = false is unsupported')
    }
  }

  file { ["${app_root}/config.ru", "${app_root}/config/environment.rb"]:
    owner => $user,
  }
}
