class foreman::install {
  include foreman::install::repos

  case $operatingsystem {
    redhat,centos,fedora: { include foreman::install::redhat }
    default: { fail("${hostname}: This module does not support operatingsystem $operatingsystem") }
  }
}
