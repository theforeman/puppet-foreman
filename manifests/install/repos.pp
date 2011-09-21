class foreman::install::repos {
  case $operatingsystem {
    redhat,centos,fedora: { include foreman::install::repos::redhat }
    default: { fail("${hostname}: This module does not support operatingsystem $operatingsystem") }
  }
}
