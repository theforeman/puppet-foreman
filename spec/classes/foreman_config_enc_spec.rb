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
        :mode   => '0550',
        :owner  => 'puppet',
        :group  => 'puppet',
        :source => 'puppet:///modules/foreman/external_node_v2.rb',
      })
    end
  end
end
