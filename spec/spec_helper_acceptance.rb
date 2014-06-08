require 'beaker-rspec/spec_helper'
require 'beaker-rspec/helpers/serverspec'

hosts.each do |host|
  # Install Puppet
  install_puppet
end

RSpec.configure do |c|
  # Project root
  proj_root = File.expand_path(File.join(File.dirname(__FILE__), '..'))

  # Readable test descriptions
  c.formatter = :documentation

  # Configure all nodes in nodeset
  c.before :suite do
    # Install module and dependencies
    puppet_module_install(:source => proj_root, :module_name => 'foreman')
    hosts.each do |host|
      on host, puppet('module', 'install', 'theforeman-concat_native'), { :acceptable_exit_codes => 0 }
      on host, puppet('module', 'install', 'theforeman-tftp'), { :acceptable_exit_codes => 0 }
      on host, puppet('module', 'install', 'puppetlabs-apache'), { :acceptable_exit_codes => 0 }
      on host, puppet('module', 'install', 'puppetlabs-postgresql'), { :acceptable_exit_codes => 0 }
      on host, puppet('module', 'install', 'puppetlabs-stdlib'), { :acceptable_exit_codes => 0 }
    end
  end
end
