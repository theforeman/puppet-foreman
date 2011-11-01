class foreman::install {
  include foreman::install::repos

  case $operatingsystem {
    Debian:  {
      package{"foreman-sqlite3":
        ensure  => latest,
        require => Class["foreman::install::repos"],
        notify  => [Class["foreman::service"],
                    Package["foreman"]],
      }
    }
    default: {}
  }

  package{"foreman":
    ensure  => latest,
    require => Class["foreman::install::repos"],
    notify  => Class["foreman::service"],
  }

}
