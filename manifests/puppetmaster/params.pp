# Defaults for the puppetmaster
class foreman::puppetmaster::params {
  $lower_fqdn = downcase($::fqdn)

  # Basic configurations
  $foreman_url      = "https://${lower_fqdn}"
  $foreman_user     = undef
  $foreman_password = undef
  # Should foreman act as an external node classifier (manage puppet class
  # assignments)
  $enc            = true
  # Should foreman receive reports from puppet
  $reports        = true
  # Should foreman receive facts from puppet
  $receive_facts  = true

  $puppet_user = 'puppet'
  $puppet_group = 'puppet'

  $puppetmaster_timeout = 60
  $puppetmaster_report_timeout = 60

  if $::rubysitedir =~ /\/opt\/puppetlabs\/puppet/ {
    $puppet_basedir = '/opt/puppetlabs/puppet/lib/ruby/vendor_ruby/puppet'
    $puppet_etcdir = '/etc/puppetlabs/puppet'
    $puppet_home = '/opt/puppetlabs/server/data/puppetserver'
    $puppet_ssldir = '/etc/puppetlabs/puppet/ssl'
  } else {
    case $::osfamily {
      'RedHat': {
        $puppet_basedir  = '/usr/share/ruby/vendor_ruby/puppet'
        $puppet_etcdir = '/etc/puppet'
        $puppet_home = '/var/lib/puppet'
      }
      'Debian': {
        $puppet_basedir  = '/usr/lib/ruby/vendor_ruby/puppet'
        $puppet_etcdir = '/etc/puppet'
        $puppet_home = '/var/lib/puppet'
      }
      'Linux': {
        case $::operatingsystem {
          'Amazon': {
            $puppet_basedir = regsubst($::rubyversion, '^(\d+\.\d+).*$', '/usr/lib/ruby/site_ruby/\1/puppet')
            $puppet_etcdir = '/etc/puppet'
            $puppet_home = '/var/lib/puppet'
          }
          default: {
            fail("${::hostname}: This module does not support operatingsystem ${::operatingsystem}")
          }
        }
      }
      'Archlinux': {
        $puppet_basedir = regsubst($::rubyversion, '^(\d+\.\d+).*$', '/usr/lib/ruby/vendor_ruby/\1/puppet')
        $puppet_etcdir = '/etc/puppetlabs/puppet'
        $puppet_home = '/var/lib/puppet'
      }
      /^(FreeBSD|DragonFly)$/: {
        $puppet_basedir = regsubst($::rubyversion, '^(\d+\.\d+).*$', '/usr/local/lib/ruby/site_ruby/\1/puppet')
        $puppet_etcdir = '/usr/local/etc/puppet'
        $puppet_home = '/var/puppet'
      }
      default: {
        $puppet_basedir = undef
        $puppet_etcdir = undef
        $puppet_home = undef
      }
    }

    $puppet_ssldir = "${puppet_home}/ssl"
  }

  # If CA is specified, remote Foreman host will be verified in reports/ENC scripts
  $client_ssl_ca   = "${puppet_ssldir}/certs/ca.pem"
  # Used to authenticate to Foreman, required if require_ssl_puppetmasters is enabled
  $client_ssl_cert = "${puppet_ssldir}/certs/${lower_fqdn}.pem"
  $client_ssl_key  = "${puppet_ssldir}/private_keys/${lower_fqdn}.pem"
}
