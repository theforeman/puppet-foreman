require 'spec_helper'

class Enc
  # Parse ERB and create a ruby object we can load - need an instance variable for ERB
  @foreman_url = 'http://localhost:3000'
  @facts       = true
  @puppet_home = '/var/lib/puppet'
  template     = File.join(File.dirname(__FILE__), '../..', 'templates', 'external_node_v2.rb.erb')
  eval ERB.new(File.read(template), nil, '-').result(binding)
end

describe 'foreman_external_node' do
  # Get our ruby
  let(:enc) { Enc.new }

  it "should connect to the URL in the manifest" do
    webstub = stub_request(:post, "http://localhost:3000/api/hosts/facts").with(:body => {"fake"=>"data"})

    enc.stubs(:stat_file).with('fake.host.fqdn.com').returns("/tmp/fake.host.fqdn.com.yaml")
    File.stubs(:exists?).returns(false)
    File.stubs(:stat).returns(stub(:mtime => Time.now.utc))
    enc.stubs(:build_body).returns({'fake' => 'data'})

    enc.upload_facts('fake.host.fqdn.com',"#{static_fixture_path}/fake.host.fqdn.com.yaml")
    webstub.should have_been_requested
  end

  it "should have the correct certname and hostname" do
    # fake2 does not appear in the fixture, so we know it
    # must be preferring the passed-in certname from ARGV
    hash = enc.build_body('fake2.host.fqdn.com',"#{static_fixture_path}/fake.host.fqdn.com.yaml")
    hash['certname'].should eql('fake2.host.fqdn.com')
    hash['name'].should eql('fake.host.fqdn.com')
    hash['facts'].should be_a(Hash)
  end

end
