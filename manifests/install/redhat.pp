class foreman::install::redhat {

  package{"foreman":
    ensure  => latest,
    require => Class["foreman::install::repos::redhat"],
    notify  => Class["foreman::service"],
  }
}
