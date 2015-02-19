# Install an apt repo
define foreman::install::repos::apt ($repo) {
  file { "/etc/apt/sources.list.d/${name}.list":
    content => "deb http://deb.theforeman.org/ ${::lsbdistcodename} ${repo}\ndeb http://deb.theforeman.org/ plugins ${repo}\n",
  } ->
  exec { "foreman-key-${name}":
    command => '/usr/bin/wget -q http://deb.theforeman.org/foreman.asc -O- | /usr/bin/apt-key add -',
    unless  => '/usr/bin/apt-key list | /bin/grep -q "Foreman Automatic Signing Key"',
  } ~>
  exec { "update-apt-${name}":
    command     => '/usr/bin/apt-get update',
    refreshonly => true,
  }
}
