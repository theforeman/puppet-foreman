require 'rbconfig'
require 'spec_helper'
require 'yaml'

if RbConfig::CONFIG['host_os'] =~ /freebsd|dragonfly/i
  $settings_file = "/usr/local/etc/puppet/foreman.yaml"
else
  $settings_file = "/etc/puppet/foreman.yaml"
end

class Enc
  yaml_text = <<-EOF
---
:url: "http://localhost:3000"
:facts: true
:puppet_home: "/var/lib/puppet"
  EOF
  yaml = YAML.load(yaml_text)
  YAML.stubs(:load_file).with($settings_file).returns(yaml)
  YAML.stubs(:load_file).with("/dev/null").returns({})
  eval File.read(File.join(File.dirname(__FILE__), '../..', 'files', 'external_node_v2.rb'))
end

describe 'foreman_external_node' do
  # Get our ruby
  let(:enc) { Enc.new }

  it "should connect to the URL in the manifest" do
    webstub = stub_request(:post, "http://localhost:3000/api/hosts/facts").with(:body => {"fake"=>"data"})

    enc.stubs(:stat_file).with('fake.host.fqdn.com-push-facts').returns("/tmp/fake.host.fqdn.com-push-facts.yaml")
    # first :exists? call is for 'push-facts'; second one for fixture facts
    File.stubs(:exists?).returns(false,true)
    File.stubs(:stat).returns(stub(:mtime => Time.now.utc))
    enc.stubs(:build_body).returns({'fake' => 'data'})

    req = enc.generate_fact_request('fake.host.fqdn.com',"#{static_fixture_path}/fake.host.fqdn.com.yaml")
    enc.upload_facts('fake.host.fqdn.com',req)
    expect(webstub).to have_been_requested

    # test pushing facts async
    http_fact_requests = []
    http_fact_requests << ['fake.host.fqdn.com', req]
    enc.upload_facts_parallel(http_fact_requests)

    expect(webstub).to have_been_requested.times(2)

    http_fact_requests << ['fake.host.fqdn.com', req]
    http_fact_requests << ['fake.host.fqdn.com', req]
    enc.upload_facts_parallel(http_fact_requests)

    expect(webstub).to have_been_requested.times(4)
  end

  it "should NOT connect to the URL in the manifest" do

    enc.stubs(:stat_file).with('fake.host.fqdn.com-push-facts').returns("/tmp/fake.host.fqdn.com-push-facts.yaml")
    # first :exists? call is for 'push-facts'; second one for non-existent facts
    File.stubs(:exists?).returns(false,false)
    File.stubs(:stat).returns(stub(:mtime => Time.now.utc))
    enc.stubs(:build_body).returns({'fake' => 'data'})

    req = enc.generate_fact_request('fake.host.fqdn.com','non-existent-facts.yaml')
    expect(req).to be_nil

  end

  it "should have the correct certname and hostname" do
    # fake2 does not appear in the fixture, so we know it
    # must be preferring the passed-in certname from ARGV
    hash = enc.build_body('fake2.host.fqdn.com',"#{static_fixture_path}/fake.host.fqdn.com.yaml")
    expect(hash['certname']).to eql 'fake2.host.fqdn.com'
    expect(hash['name']).to eql 'fake.host.fqdn.com'
    expect(hash['facts']).to be_a(Hash)
  end

end
