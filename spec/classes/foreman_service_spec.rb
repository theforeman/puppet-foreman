require 'spec_helper'

describe 'foreman::service' do

  context 'with inherited parameters' do
    let :facts do
      on_supported_os['redhat-7-x86_64']
    end

    let :pre_condition do
      'include ::foreman'
    end

    it { is_expected.to compile.with_all_deps }
    it { is_expected.to contain_service('dynflowd').with_ensure('running').with_enable(true) }

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
    let :facts do
      on_supported_os['redhat-7-x86_64']
    end

    let :params do
      {
        :passenger           => true,
        :app_root            => '/usr/share/foreman',
        :ssl                 => true,
        :jobs_service        => 'dynflower',
        :jobs_service_ensure => 'stopped',
        :jobs_service_enable => false,
      }
    end

    let :pre_condition do
      'include ::apache'
    end

    it { is_expected.to compile.with_all_deps }
    it { is_expected.to contain_service('dynflower').with_ensure('stopped').with_enable(false) }

    it 'should restart passenger' do
      should contain_exec('restart_foreman').with({
        :command     => '/bin/touch /usr/share/foreman/tmp/restart.txt',
        :refreshonly => true,
        :cwd         => '/usr/share/foreman',
        :path        => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
      })
    end

    it { should contain_service('httpd').that_requires('Anchor[foreman::service_begin]') }
    it { should contain_class('apache').that_comes_before('Anchor[foreman::service_end]') }

    it { should contain_service('foreman').with({
      'ensure'    => 'stopped',
      'enable'    => false,
      'hasstatus' => true,
    })}

    context 'without ssl' do
      let :params do
        {
          :passenger           => true,
          :app_root            => '/usr/share/foreman',
          :ssl                 => false,
          :jobs_service        => 'dynflowd',
          :jobs_service_ensure => 'running',
          :jobs_service_enable => true,
        }
      end

      it { is_expected.to compile.with_all_deps }
    end
  end

  context 'without passenger' do
    let :params do
      {
        :passenger           => false,
        :app_root            => '/usr/share/foreman',
        :ssl                 => true,
        :jobs_service        => 'dynflowd',
        :jobs_service_ensure => 'running',
        :jobs_service_enable => true,
      }
    end

    it { is_expected.to compile.with_all_deps }

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
