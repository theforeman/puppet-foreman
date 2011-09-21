class foreman::config::reports {

  # foreman reporter
  file {"${foreman::params::puppet_basedir}/reports/foreman.rb":
    mode    => 444,
    owner   => puppet,
    group   => puppet,
    content => template("foreman/foreman-report.rb.erb"),
    # notify => Service["puppetmaster"],
  }

  cron { 
    "expire_old_reports":
      command => "(cd $foreman::params::app_root && rake reports:expire)",
      minute  => "30",
      hour    => "7",
  }

  cron{"daily summary":
    command => "(cd $foreman::params::app_root && rake reports:summarize)",
    minute  => "31",
    hour    => "7",
  }



}
