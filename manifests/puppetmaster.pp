# This class includes the necessary scripts for Foreman on the puppetmaster and
# is intented to be added to your puppetmaster
class foreman::puppetmaster (
  $foreman_url    = $foreman::params::foreman_url,
  $reports        = $foreman::params::reports,
  $enc            = $foreman::params::enc,
  $facts          = $foreman::params::facts,
  $puppet_home    = $foreman::params::puppet_home,
  $puppet_basedir = $foreman::params::puppet_basedir,
  $ssl_ca         = $foreman::params::client_ssl_ca,
  $ssl_cert       = $foreman::params::client_ssl_cert,
  $ssl_key        = $foreman::params::client_ssl_key
) inherits foreman::params {

  if $reports {   # foreman reporter
    exec { 'Create Puppet Reports dir':
      command => "/bin/mkdir -p ${puppet_basedir}/reports",
      creates => "${puppet_basedir}/reports"
    }
    file {"${puppet_basedir}/reports/foreman.rb":
      mode     => '0644',
      owner    => 'root',
      group    => 'root',
      content  => template('foreman/foreman-report.rb.erb'),
      require  => Exec['Create Puppet Reports dir'],
    }
  }

  if $enc {
    class {'foreman::config::enc':
      foreman_url => $foreman_url,
      facts       => $facts,
      puppet_home => $puppet_home,
      ssl_ca      => $ssl_ca,
      ssl_cert    => $ssl_cert,
      ssl_key     => $ssl_key
    }
  }
}
