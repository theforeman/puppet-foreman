# Workaround class to so Kafo understands the parameters.
class foreman::plugin::puppetdb::params {
  $enabled = true
  $address = "https://puppetdb.${::domain}:8081/v2/commands"
}
