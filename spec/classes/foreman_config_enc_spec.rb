require 'spec_helper'

describe 'foreman::config::enc' do

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

  describe 'with v1 enc api' do
    let :pre_condition do
      "class {'foreman::config::enc': enc_api => 'v1'}"
    end

    it 'should set up the v1 enc' do
      should contain_file('/etc/puppet/node.rb').with({
        :content => %r{fact_values/create},
        :mode    => '0550',
        :owner   => 'puppet',
        :group   => 'puppet',
      })
    end

  end
end
