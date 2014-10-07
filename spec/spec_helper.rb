# This file is managed centrally by modulesync
#   https://github.com/theforeman/foreman-installer-modulesync

require 'puppetlabs_spec_helper/module_spec_helper'
require 'webmock/rspec'
require 'puppet/reports'

# Workaround for no method in rspec-puppet to pass undef through :params
class Undef
  def inspect; 'undef'; end
end

def static_fixture_path
  File.join(File.dirname(__FILE__), 'static_fixtures')
end

RSpec.configure do |c|
  c.before :each do
    if Gem::Version.new(`puppet --version`) >= Gem::Version.new('3.5')
      Puppet.settings[:strict_variables]=true
    end
  end
end
