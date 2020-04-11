require 'voxpupuli/acceptance/spec_helper_acceptance'

ENV['BEAKER_setfile'] ||= 'centos7-64{hostname=centos7-64.example.com}'

configure_beaker do |host|
  if fact_on(host, 'os.family') == 'RedHat'
    unless fact_on(host, 'os.name') == 'Fedora'
      # don't delete downloaded rpm for use with BEAKER_provision=no +
      # BEAKER_destroy=no
      on host, 'sed -i "s/keepcache=.*/keepcache=1/" /etc/yum.conf'
    end
    # refresh check if cache needs refresh on next yum command
    on host, 'yum clean expire-cache'
  end

  local_setup = File.join(__dir__, 'setup_acceptance_node.pp')
  if File.exist?(local_setup)
    puts "Configuring #{host} by applying #{local_setup}"
    apply_manifest_on(host, File.read(local_setup), catch_failures: true)
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
    path = File.join(File.dirname(__dir__), 'examples', name)
    File.read(path)
  end

  include_examples 'a idempotent resource'
end

Dir["./spec/support/acceptance/**/*.rb"].sort.each { |f| require f }
