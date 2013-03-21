require 'puppet'
require 'puppet/type/foreman_user'

describe Puppet::Type.type(:foreman_user) do
  subject { Puppet::Type.type(:foreman_user).new(:login => 'foo') }

  it 'should accept ensure' do
    subject[:ensure] = :present
    subject[:ensure].should == :present
  end

  it 'should fail for invalid login' do
    expect{subject[:login] = 'foo 123'}.to raise_error(Puppet::Error)
    expect{subject[:login] = 'foo#123'}.to raise_error(Puppet::Error)
    expect{subject[:login] = 'foo.123'}.to raise_error(Puppet::Error)
    expect{subject[:login] = 'foo@123'}.to raise_error(Puppet::Error)
  end

  it 'should accept a valid login' do
    subject[:login] = 'foo_123'
    subject[:login].should == 'foo_123'
  end

  it 'should fail for invalid admin right' do
    expect{subject[:admin] = :foo}.to raise_error(Puppet::Error)
  end

  it 'should accept a valid admin right' do
    subject[:admin] = :true
    subject[:admin].should == :true
    subject[:admin] = :false
    subject[:admin].should == :false
  end

  it 'should accept a firstname' do
    subject[:firstname] = 'John'
    subject[:firstname].should == 'John'
  end

  it 'should accept a lastname' do
    subject[:lastname] = 'Doe'
    subject[:lastname].should == 'Doe'
  end

  it 'should fail for invalid e-mail' do
    expect{subject[:mail] = 'john.doe@example'}.to raise_error(Puppet::Error)
    expect{subject[:mail] = 'john.doe@example.dotcom'}.to raise_error(Puppet::Error)
    expect{subject[:mail] = 'john.doe@example@com'}.to raise_error(Puppet::Error)
    expect{subject[:mail] = 'john.doë@example.com'}.to raise_error(Puppet::Error)
    expect{subject[:mail] = '.john.doe@example.com'}.to raise_error(Puppet::Error)
    expect{subject[:mail] = 'john.doe@.example.com'}.to raise_error(Puppet::Error)
  end

  it 'should accept a valid e-mail' do
    subject[:mail] = 'john.doe@example.com'
    subject[:mail].should == 'john.doe@example.com'
    subject[:mail] = 'John.Doe@Example.Com'
    subject[:mail].should == 'John.Doe@Example.Com'
    subject[:mail] = 'john.doe@mx.example.com'
    subject[:mail].should == 'john.doe@mx.example.com'
    subject[:mail] = 'john.doe@mx-1.example.com'
    subject[:mail].should == 'john.doe@mx-1.example.com'
  end

end
