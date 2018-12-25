ENV['PUPPET_INSTALL_TYPE'] ||= 'agent'
ENV['BEAKER_IS_PE'] ||= 'no'
ENV['BEAKER_PUPPET_COLLECTION'] ||= 'puppet6'
ENV['BEAKER_debug'] ||= 'true'
ENV['BEAKER_setfile'] ||= 'centos7-64{hostname=centos7-64.example.com}'
ENV['BEAKER_HYPERVISOR'] ||= 'docker'

require 'beaker-puppet'
require 'beaker-rspec'
require 'beaker/puppet_install_helper'
require 'beaker/module_install_helper'

run_puppet_install_helper unless ENV['BEAKER_provision'] == 'no'
install_module_on(hosts)
install_module_dependencies_on(hosts)

RSpec.configure do |c|
  # Readable test descriptions
  c.formatter = :documentation

  # Configure all nodes in nodeset
  c.before :suite do
    # Install module and dependencies
    hosts.each do |host|
      if fact_on(host, 'osfamily') == 'RedHat'
        # don't delete downloaded rpm for use with BEAKER_provision=no +
        # BEAKER_destroy=no
        on host, 'sed -i "s/keepcache=.*/keepcache=1/" /etc/yum.conf'
        # refresh check if cache needs refresh on next yum command
        on host, 'yum clean expire-cache'
      end
    end
  end
end

shared_examples 'a idempotent resource' do
  it 'applies with no errors' do
    apply_manifest(pp, catch_failures: true)
  end

  it 'applies a second time without changes' do
    apply_manifest(pp, catch_changes: true)
  end
end

shared_examples 'the example' do |name|
  let(:pp) do
    path = File.join(File.dirname(File.dirname(__FILE__)), 'examples', name)
    File.read(path)
  end

  include_examples 'a idempotent resource'
end

Dir["./spec/support/acceptance/**/*.rb"].sort.each { |f| require f }
