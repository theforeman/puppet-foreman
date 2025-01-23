class { 'foreman::repo':
  repo => 'nightly',
}

if $facts['os']['family'] == 'RedHat' {
  yumrepo { 'katello':
    baseurl  => "http://yum.theforeman.org/katello/nightly/katello/el${facts['os']['release']['major']}/x86_64/",
    gpgcheck => 0,
  }
  yumrepo { 'candlepin':
    baseurl  => "https://yum.theforeman.org/candlepin/4.4/el${facts['os']['release']['major']}/x86_64/",
    gpgcheck => 0,
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
