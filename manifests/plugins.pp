class foreman::plugins (
  $foreman_hipchat_token = undef,
  $foreman_hipchat_room  = undef,
) {

  package { 'git':
    ensure => present,
  } ->
  file { "${foreman::app_root}/bundler.d/Gemfile.local.rb":
    ensure  => file,
    content => template('foreman/Gemfile.local.rb.erb'),
  } ~>
  exec { 'foreman_plugin_update':
    user        => $foreman::user,
    cwd         => $foreman::app_root,
    command     => '/usr/bin/bundle update',
    refreshonly => true,
  }

  $home = '/usr/share/foreman'

  package { 'python-pip':
    ensure => present,
  } ->
  package { 'python-simple-hipchat':
    ensure  => present,
    provider => 'pip',
  }

  file { [ "${home}/config/hooks",
           "${home}/config/hooks/host",
           "${home}/config/hooks/host/managed",
           "${home}/config/hooks/host/managed/before_provision"
  ]:
    ensure => directory,
    owner  => 'foreman',
    group  => 'foreman',
    mode   => '0770',
  } ->
  file { "${home}/config/hooks/host/managed/before_provision/10_hipchat.py":
    ensure  => file,
    owner   => 'foreman',
    group   => 'foreman',
    mode    => '0770',
    content => template('foreman/10_hipchat.py.erb'),
  }

}
