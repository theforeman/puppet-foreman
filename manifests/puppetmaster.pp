# This class includes the necessary scripts for Foreman on the puppetmaster and is intented to be added to your puppetmaster
class foreman::puppetmaster {
  include foreman::params

  if $foreman::params::reports {   # foreman reporter
    file {"${foreman::params::puppet_basedir}/reports/foreman.rb":
      mode     => '0444',
      owner    => 'puppet',
      group    => 'puppet',
      content  => template('foreman/foreman-report.rb.erb'),
      # notify => Service["puppetmaster"],
    }
  }

  if $foreman::params::enc     { include foreman::config::enc }
}
