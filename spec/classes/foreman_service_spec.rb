require 'spec_helper'

describe 'foreman::service' do

  context 'with inherited parameters' do
    let :facts do
      on_supported_os['redhat-7-x86_64'].merge({:concat_basedir => '/doesnotexist'})
    end

    let :pre_condition do
      'include ::foreman'
    end

    it 'should restart passenger' do
      should contain_exec('restart_foreman').with({
        :command     => '/bin/touch /usr/share/foreman/tmp/restart.txt',
        :refreshonly => true,
        :cwd         => '/usr/share/foreman',
        :path        => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
      })
    end

    it { should contain_service('foreman').with({
      'ensure'    => 'stopped',
      'enable'    => false,
      'hasstatus' => true,
    })}
  end

  context 'with passenger' do
    let :params do
      {
        :passenger => true,
        :app_root  => '/usr/share/foreman',
      }
    end

    it 'should restart passenger' do
      should contain_exec('restart_foreman').with({
        :command     => '/bin/touch /usr/share/foreman/tmp/restart.txt',
        :refreshonly => true,
        :cwd         => '/usr/share/foreman',
        :path        => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
      })
    end

    it { should contain_service('foreman').with({
      'ensure'    => 'stopped',
      'enable'    => false,
      'hasstatus' => true,
    })}
  end

  context 'without passenger' do
    let :params do
      {
        :passenger => false,
        :app_root  => '/usr/share/foreman',
      }
    end

    it 'should not restart passenger' do
      should_not contain_exec('restart_foreman')
    end

    it { should contain_service('foreman').with({
      'ensure'    => 'running',
      'enable'    => true,
      'hasstatus' => true,
    })}
  end
end
