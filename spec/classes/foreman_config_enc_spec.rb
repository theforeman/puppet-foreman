require 'spec_helper'

describe 'foreman::config::enc' do
  let :facts do
    {
      :osfamily => 'RedHat',
    }
  end

  describe 'without custom parameters' do
    it 'should set up enc' do
      should contain_file('/etc/puppet/node.rb').with({
        :content => %r{api/hosts/facts},
        :mode    => '0550',
        :owner   => 'puppet',
        :group   => 'puppet',
      })
    end
  end
end
