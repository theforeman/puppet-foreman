require 'spec_helper'

describe 'foreman::install' do
  let :default_facts do
    {
      :concat_basedir => '/tmp',
      :interfaces     => '',
    }
  end

  context 'RedHat' do
    let :facts do
      default_facts.merge({
        :operatingsystem        => 'RedHat',
        :operatingsystemrelease => '6.4',
        :osfamily               => 'RedHat',
      })
    end

    describe 'without parameters' do
      let :pre_condition do
        "class {'foreman':}"
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

    describe 'with passenger' do
      let :pre_condition do
        "class {'foreman':
          passenger => true,
        }"
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

    describe 'without passenger' do
      let :pre_condition do
        "class {'foreman':
          passenger => false,
        }"
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
end
