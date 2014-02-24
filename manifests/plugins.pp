class foreman::plugins {

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

}
