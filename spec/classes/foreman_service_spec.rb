require 'spec_helper'

describe 'foreman::install' do
  let :default_facts do
    {
      :concat_basedir           => '/tmp',
      :interfaces               => '',
      :postgres_default_version => '8.4',
    }
  end

  context 'RedHat' do
    let :facts do
      default_facts.merge({
        :operatingsystem => 'RedHat',
        :osfamily        => 'RedHat',
      })
    end

    describe 'without parameters' do
      let :pre_condition do
        "class {'foreman':}"
      end

      it { should contain_service('foreman').with({
        'ensure'    => 'stopped',
        'enable'    => false,
        'hasstatus' => true,
      })}
    end

    describe 'with passenger' do
      let :pre_condition do
        "class {'foreman':
          passenger => true,
        }"
      end

      it { should contain_service('foreman').with({
        'ensure'    => 'stopped',
        'enable'    => false,
        'hasstatus' => true,
      })}
    end

    describe 'without passenger' do
      let :pre_condition do
        "class {'foreman':
          passenger => false,
        }"
      end

      it { should contain_service('foreman').with({
        'ensure'    => 'running',
        'enable'    => true,
        'hasstatus' => true,
      })}
    end
  end
end
