class foreman::config::reports {

  cron { 'expire_old_reports':
    command => "(cd ${foreman::params::app_root} && rake reports:expire)",
    minute  => '30',
    hour    => '7',
  }

  cron { 'daily summary':
    command => "(cd ${foreman::params::app_root} && rake reports:summarize)",
    minute  => '31',
    hour    => '7',
  }



}
