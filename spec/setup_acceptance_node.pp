class { 'foreman::repo':
  repo => 'nightly',
}

# Needed for idempotency when SELinux is enabled
if $facts['os']['selinux']['enabled'] {
  package { 'foreman-selinux':
    ensure  => latest,
    require => Class['foreman::repo'],
  }

  if $foreman::repo::configure_scl_repo {
    package { 'rh-redis5-redis':
      ensure  => installed,
      require => Class['foreman::repo'],
    }
  }
}

# Not /etc/foreman because purging removes that
$directory = '/etc/foreman-certs'
$certificate = "${directory}/certificate.pem"
$key = "${directory}/key.pem"

exec { 'Create certificate directory':
  command => "mkdir -p ${directory}",
  path    => ['/bin', '/usr/bin'],
  creates => $directory,
}
-> exec { 'Generate certificate':
  command => "openssl req -nodes -x509 -newkey rsa:2048 -subj '/CN=${facts['networking']['fqdn']}' -keyout '${key}' -out '${certificate}' -days 365",
  path    => ['/bin', '/usr/bin'],
  creates => $certificate,
  umask   => '0022',
}
-> file { [$key, $certificate]:
  owner => 'root',
  group => 'root',
  mode  => '0640',
}
