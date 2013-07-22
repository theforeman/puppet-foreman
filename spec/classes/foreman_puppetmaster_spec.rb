require 'spec_helper'

describe 'foreman::puppetmaster' do
  let :facts do
    {
      :fqdn        => 'hostname.example.org',
      :rubyversion => '1.8.7',
    }
  end

  describe 'without custom parameters' do
    it 'should set up reports' do
      should contain_exec('Create Puppet Reports dir').with({
        :command => '/bin/mkdir -p /usr/lib/ruby/1.8/puppet/reports',
        :creates => '/usr/lib/ruby/1.8/puppet/reports',
      })

      should contain_file('/usr/lib/ruby/1.8/puppet/reports/foreman.rb').with({
        :mode    => '0644',
        :owner   => 'root',
        :group   => 'root',
        :require => 'Exec[Create Puppet Reports dir]',
      })
    end

    it 'should set up enc' do
      should contain_class('foreman::config::enc').with({
        :foreman_url    => "https://#{facts[:fqdn]}",
        :facts          => true,
        :puppet_home    => '/var/lib/puppet',
        :ssl_ca         => '/var/lib/puppet/ssl/certs/ca.pem',
        :ssl_cert       => "/var/lib/puppet/ssl/certs/#{facts[:fqdn]}.pem",
        :ssl_key        => "/var/lib/puppet/ssl/private_keys/#{facts[:fqdn]}.pem",
      })
    end
  end

  describe 'without reports' do
    let :pre_condition do
      "class {'foreman::puppetmaster': reports => false}"
    end

    it 'should not include reports' do
      should_not contain_exec('Create Puppet Reports dir')

      should_not contain_file('/usr/lib/ruby/1.8/puppet/reports/foreman.rb')
    end
  end

  describe 'without enc' do
    let :pre_condition do
      "class {'foreman::puppetmaster': enc => false}"
    end

    it 'should not include enc' do
      should_not contain_class('foreman::config::enc')
    end
  end
end
