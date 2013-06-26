require 'spec_helper'


describe 'foreman::config' do
  let :default_facts do
    {
      :concat_basedir           => '/tmp',
      :interfaces               => '',
      :postgres_default_version => '8.4',
    }
  end

  context 'on redhat' do
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

      it { should contain_concat_build('foreman_settings').with({
        'order' => ['*.yaml'],
      })}

      it {
        should contain_concat_fragment('foreman_settings+01-header.yaml').with({'content' => /:login:\s*true/ })
        should contain_concat_fragment('foreman_settings+01-header.yaml').with({'content' => /:require_ssl:\s*true/ })
        should contain_concat_fragment('foreman_settings+01-header.yaml').with({'content' => /:oauth_consumer_secret:\s*\w+/ })
      }

      it { should contain_file('/etc/foreman/settings.yaml').with({
        'source'  => /\/tmp\/.+\/concat\/output\/foreman_settings.out/,
        'require' => 'Concat_build[foreman_settings]',
        'notify'  => 'Class[Foreman::Service]',
        'owner'   => 'root',
        'group'   => 'foreman',
        'mode'    => '0640',
      })}

      it { should contain_file('/etc/foreman/database.yml').with({
        'owner'   => 'root',
        'group'   => 'foreman',
        'mode'    => '0640',
        'content' => /adapter: postgresql/,
        'notify'  => 'Class[Foreman::Service]',
      })}

      it { should contain_file('/etc/sysconfig/foreman').with({
        'ensure'  => 'present',
        'content' => //, # TODO ensure foreman.sysconfig is loaded
        'require' => 'Class[Foreman::Install]',
        'before'  => 'Class[Foreman::Service]',
      })}

      it { should contain_file('/usr/share/foreman').with({
        'ensure'  => 'directory',
      })}

      it { should contain_user('foreman').with({
        'ensure'  => 'present',
        'shell'   => '/sbin/nologin',
        'comment' => 'Foreman',
        'home'    => '/usr/share/foreman',
        'require' => 'Class[Foreman::Install]',
      })}

      it { should contain_cron('clear_session_table').with({
        'ensure'      => 'absent',
        'require'     => 'User[foreman]',
        'user'        => 'foreman',
        'environment' => 'RAILS_ENV=production'
      })}

      it { should contain_cron('expire_old_reports').with({
        'ensure'      => 'absent',
        'require'     => 'User[foreman]',
        'user'        => 'foreman',
        'environment' => 'RAILS_ENV=production'
      })}

      it { should contain_cron('daily summary').with({
        'ensure'      => 'absent',
        'require'     => 'User[foreman]',
        'user'        => 'foreman',
        'environment' => 'RAILS_ENV=production'
      })}

      it { should contain_class('foreman::config::passenger').with({
        :listen_on_interface => '',
        :scl_prefix          => 'ruby193',
      })}
    end

    describe 'without passenger' do
      let :pre_condition do
        "class {'foreman':
          passenger => false,
        }"
      end

      it { should_not contain_class('foreman::config::passenger') }
    end

    describe 'with passenger interface' do
      let :pre_condition do
        "class {'foreman':
          passenger_interface => 'lo',
        }"
      end

      it { should contain_class('foreman::config::passenger').with({
        :listen_on_interface => 'lo',
      })}
    end
  end

  context 'on debian' do
    let :facts do
      default_facts.merge({
        :operatingsystem => 'Debian',
        :osfamily        => 'Debian',
      })
    end

    describe 'without parameters' do
      let :pre_condition do
        "class {'foreman':}"
      end

      it { should contain_concat_build('foreman_settings').with({
        'order' => ['*.yaml'],
      })}

      it { should contain_concat_fragment('foreman_settings+01-header.yaml').with({
        'content' => //, # TODO verify content
      })}

      it { should contain_file('/etc/foreman/settings.yaml').with({
        'source'  => /\/tmp\/.+\/concat\/output\/foreman_settings.out/,
        'require' => 'Concat_build[foreman_settings]',
        'notify'  => 'Class[Foreman::Service]',
        'owner'   => 'root',
        'group'   => 'foreman',
        'mode'    => '0640',
      })}

      it { should contain_file('/etc/foreman/database.yml').with({
        'owner'   => 'root',
        'group'   => 'foreman',
        'mode'    => '0640',
        'content' => /adapter: postgresql/,
        'notify'  => 'Class[Foreman::Service]',
      })}

      it { should contain_file('/etc/default/foreman').with({
        'ensure'  => 'present',
        'content' => //, # TODO verify foreman.default is loaded
        'require' => 'Class[Foreman::Install]',
        'before'  => 'Class[Foreman::Service]',
      })}

      it { should contain_file('/usr/share/foreman').with({
        'ensure'  => 'directory',
      })}

      it { should contain_user('foreman').with({
        'ensure'  => 'present',
        'shell'   => '/sbin/nologin',
        'comment' => 'Foreman',
        'home'    => '/usr/share/foreman',
        'require' => 'Class[Foreman::Install]',
      })}

      it { should contain_cron('clear_session_table').with({
        'ensure'      => 'absent',
        'require'     => 'User[foreman]',
        'user'        => 'foreman',
        'environment' => 'RAILS_ENV=production'
      })}

      it { should contain_cron('expire_old_reports').with({
        'ensure'      => 'absent',
        'require'     => 'User[foreman]',
        'user'        => 'foreman',
        'environment' => 'RAILS_ENV=production'
      })}

      it { should contain_cron('daily summary').with({
        'ensure'      => 'absent',
        'require'     => 'User[foreman]',
        'user'        => 'foreman',
        'environment' => 'RAILS_ENV=production'
      })}

      it { should contain_class('foreman::config::passenger').with({
        :listen_on_interface => '',
        :scl_prefix          => '',
      })}
    end
  end
end
