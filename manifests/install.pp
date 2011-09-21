class foreman::install {
  include foreman::install::repos

  package{"foreman":
    ensure  => latest,
    require => Class["foreman::install::repos"],
    notify  => Class["foreman::service"],
  }

}
