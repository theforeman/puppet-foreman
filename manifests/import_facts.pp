class foreman::import_facts {

  file {"/etc/puppet/push_facts.rb":
    mode => 555,
    owner => puppet, group => puppet,
    source => "puppet:///modules/foreman/push_facts.rb",
    ensure => $using_store_configs ? {
      true => "absent",
      false => "present"
    },
  }

  cron{"send_facts_to_foreman":
    command  => "/etc/puppet/push_facts.rb",
    user  => "puppet",
    minute => "*/2",
    ensure => $using_store_configs ? {
      true => "absent",
      false => "present"
    },
  }

}
