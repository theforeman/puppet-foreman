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

      it 'should set up the config' do
        should contain_concat_build('foreman_settings').with_order(['*.yaml'])

        should contain_concat_fragment('foreman_settings+01-header.yaml').
          with_content(/^:unattended:\s*true$/).
          with_content(/^:login:\s*true$/).
          with_content(/^:require_ssl:\s*true$/).
          with_content(/^:locations_enabled:\s*false$/).
          with_content(/^:organizations_enabled:\s*false$/).
          with_content(/^:oauth_active:\s*true$/).
          with_content(/^:oauth_map_users:\s*true$/).
          with_content(/^:oauth_consumer_key:\s*\w+$/).
          with_content(/^:oauth_consumer_secret:\s*\w+$/).
          with({})

        should contain_file('/etc/foreman/settings.yaml').with({
          'source'  => %r{/concat/output/foreman_settings.out$},
          'require' => 'Concat_build[foreman_settings]',
          'notify'  => 'Class[Foreman::Service]',
          'owner'   => 'root',
          'group'   => 'foreman',
          'mode'    => '0640',
        })

        should contain_file('/etc/foreman/database.yml').with({
          'owner'   => 'root',
          'group'   => 'foreman',
          'mode'    => '0640',
          'content' => /adapter: postgresql/,
          'notify'  => 'Class[Foreman::Service]',
        })

        should contain_file('/etc/sysconfig/foreman').
          with_content(/^FOREMAN_HOME=\/usr\/share\/foreman$/).
          with_content(/^FOREMAN_USER=foreman$/).
          with_content(/^FOREMAN_ENV=production/).
          with_content(/^FOREMAN_USE_PASSENGER=1$/).
          with({
            'ensure'  => 'present',
            'require' => 'Class[Foreman::Install]',
            'before'  => 'Class[Foreman::Service]',
          })
      end

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

      it 'should remove old crons' do
        should contain_cron('clear_session_table').with({
          'ensure'      => 'absent',
          'require'     => 'User[foreman]',
          'user'        => 'foreman',
          'environment' => 'RAILS_ENV=production'
        })

        should contain_cron('expire_old_reports').with({
          'ensure'      => 'absent',
          'require'     => 'User[foreman]',
          'user'        => 'foreman',
          'environment' => 'RAILS_ENV=production'
        })

        should contain_cron('daily summary').with({
          'ensure'      => 'absent',
          'require'     => 'User[foreman]',
          'user'        => 'foreman',
          'environment' => 'RAILS_ENV=production'
        })
      end

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

    describe 'with different template parameters' do
      let :pre_condition do
        "class {'foreman':
          unattended            => false,
          authentication        => false,
          ssl                   => false,
          locations_enabled     => true,
          organizations_enabled => true,
          oauth_active          => false,
          oauth_map_users       => false,
          oauth_consumer_key    => 'abc',
          oauth_consumer_secret => 'def',
        }"
      end

      it 'should have changed parameters' do
        should contain_concat_fragment('foreman_settings+01-header.yaml').
          with_content(/^:unattended:\s*false$/).
          with_content(/^:login:\s*false$/).
          with_content(/^:require_ssl:\s*false$/).
          with_content(/^:locations_enabled:\s*true$/).
          with_content(/^:organizations_enabled:\s*true$/).
          with_content(/^:oauth_active:\s*false$/).
          with_content(/^:oauth_map_users:\s*false$/).
          with_content(/^:oauth_consumer_key:\s*abc$/).
          with_content(/^:oauth_consumer_secret:\s*def$/).
          with({})
      end
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

      it 'should set up the config' do
        should contain_concat_build('foreman_settings').with_order(['*.yaml'])

        should contain_concat_fragment('foreman_settings+01-header.yaml').
          with_content(/^:unattended:\s*true$/).
          with_content(/^:login:\s*true$/).
          with_content(/^:require_ssl:\s*true$/).
          with_content(/^:locations_enabled:\s*false$/).
          with_content(/^:organizations_enabled:\s*false$/).
          with_content(/^:oauth_active:\s*true$/).
          with_content(/^:oauth_map_users:\s*true$/).
          with_content(/^:oauth_consumer_key:\s*\w+$/).
          with_content(/^:oauth_consumer_secret:\s*\w+$/).
          with({})

        should contain_file('/etc/foreman/settings.yaml').with({
          'source'  => %r{/concat/output/foreman_settings.out$},
          'require' => 'Concat_build[foreman_settings]',
          'notify'  => 'Class[Foreman::Service]',
          'owner'   => 'root',
          'group'   => 'foreman',
          'mode'    => '0640',
        })

        should contain_file('/etc/foreman/database.yml').with({
          'owner'   => 'root',
          'group'   => 'foreman',
          'mode'    => '0640',
          'content' => /adapter: postgresql/,
          'notify'  => 'Class[Foreman::Service]',
        })

        should contain_file('/etc/default/foreman').
          with_content(/^START=no$/).
          with_content(/^FOREMAN_HOME=\/usr\/share\/foreman$/).
          with_content(/^FOREMAN_USER=foreman$/).
          with_content(/^FOREMAN_ENV=production/).
          with({
            'ensure'  => 'present',
            'require' => 'Class[Foreman::Install]',
            'before'  => 'Class[Foreman::Service]',
          })
      end

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

      it 'should remove old crons' do
        should contain_cron('clear_session_table').with({
          'ensure'      => 'absent',
          'require'     => 'User[foreman]',
          'user'        => 'foreman',
          'environment' => 'RAILS_ENV=production'
        })

        should contain_cron('expire_old_reports').with({
          'ensure'      => 'absent',
          'require'     => 'User[foreman]',
          'user'        => 'foreman',
          'environment' => 'RAILS_ENV=production'
        })

        should contain_cron('daily summary').with({
          'ensure'      => 'absent',
          'require'     => 'User[foreman]',
          'user'        => 'foreman',
          'environment' => 'RAILS_ENV=production'
        })
      end

      it { should contain_class('foreman::config::passenger').with({
        :listen_on_interface => '',
        :scl_prefix          => '',
      })}
    end
  end
end
