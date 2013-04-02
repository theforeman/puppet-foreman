require 'puppet'
require 'puppet/type/foreman_smartproxy'

describe Puppet::Type.type(:foreman_smartproxy) do
  subject { Puppet::Type.type(:foreman_smartproxy).new(:name => 'foo') }

  it 'should accept ensure' do
    subject[:ensure] = :present
    subject[:ensure].should == :present
  end

  it 'should accept a valid name' do
    subject[:name] = 'foo'
    subject[:name].should == 'foo'
  end

  it 'should fail for invalid url' do
    expect{subject[:url] = 'ftp://example.com'}.to raise_error(Puppet::Error)
    expect{subject[:url] = 'http://example.com/file.html'}.to raise_error(Puppet::Error)
    expect{subject[:url] = 'http://-example.com'}.to raise_error(Puppet::Error)
  end

  it 'should accept a valid url' do
    subject[:url] = 'http://example'
    subject[:url].should == 'http://example'
    subject[:url] = 'https://example'
    subject[:url].should == 'https://example'
    subject[:url] = 'http://example.com'
    subject[:url].should == 'http://example.com'
    subject[:url] = 'https://example.com'
    subject[:url].should == 'https://example.com'
    subject[:url] = 'http://example.com:8080'
    subject[:url].should == 'http://example.com:8080'
    subject[:url] = 'https://example.com:8443'
    subject[:url].should == 'https://example.com:8443'
    subject[:url] = 'http://Example.Com'
    subject[:url].should == 'http://Example.Com'
  end
end
