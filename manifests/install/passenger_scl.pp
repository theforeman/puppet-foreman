# Extra package with passenger libs compiled against the SCL
#
# Layered on top of the regular mod_passenger installation, which is compiled
# for the regular system Ruby.
class foreman::install::passenger_scl($prefix) {
  package{ "${prefix}-rubygem-passenger-native":
    ensure  => installed,
    require => Package['httpd'],
    before  => Service['httpd'],
  }
}