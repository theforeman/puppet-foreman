class foreman::config::enc {
  file{
    "/etc/puppet/node.rb":
      content => template("foreman/external_node.rb.erb"),
      mode    => 550,
      owner   => "puppet",
      group   => "puppet";
    "${foreman::params::puppet_home}/yaml/foreman":
      ensure => directory,
      mode    => 640,
      owner   => "puppet",
      group   => "puppet";
  }
}
