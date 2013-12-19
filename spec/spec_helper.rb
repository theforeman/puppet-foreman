require 'puppetlabs_spec_helper/module_spec_helper'
require 'webmock/rspec'
require 'puppet/reports'

fixture_path = File.expand_path(File.join(__FILE__, '..', 'fixtures'))

def static_fixture_path
  File.join(File.dirname(__FILE__), 'static_fixtures')
end

RSpec.configure do |c|
  c.module_path = File.join(fixture_path, 'modules')
  c.manifest_dir = File.join(fixture_path, 'manifests')
  c.mock_with :mocha
end
