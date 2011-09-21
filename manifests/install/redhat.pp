class foreman::install::redhat {

  package{"foreman":
    ensure  => latest,
    require => Class["foreman::install::repos"],
    notify  => Class["foreman::service"],
  }
}
