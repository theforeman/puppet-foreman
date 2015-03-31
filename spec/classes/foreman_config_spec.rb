require 'spec_helper'


describe 'foreman::config' do
  let :default_facts do
    {
      :concat_basedir => '/tmp',
      :interfaces     => '',
    }
  end

  context 'on redhat' do
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

      it 'should set up the config' do
        should contain_concat_build('foreman_settings').with_order(['*.yaml'])

        should contain_concat_fragment('foreman_settings+01-header.yaml').
          with_content(/^:unattended:\s*true$/).
          with_content(/^:login:\s*true$/).
          with_content(/^:require_ssl:\s*true$/).
          with_content(/^:locations_enabled:\s*false$/).
          with_content(/^:organizations_enabled:\s*false$/).
          with_content(/^:oauth_active:\s*true$/).
          with_content(/^:oauth_map_users:\s*false$/).
          with_content(/^:oauth_consumer_key:\s*\w+$/).
          with_content(/^:oauth_consumer_secret:\s*\w+$/).
          with({})

        should contain_file('/etc/foreman/settings.yaml').with({
          'source'  => %r{/concat_native/output/foreman_settings.out$},
          'require' => 'Concat_build[foreman_settings]',
          'owner'   => 'root',
          'group'   => 'foreman',
          'mode'    => '0640',
        })
      end

      it 'should configure the database' do
        should contain_file('/etc/foreman/database.yml').with({
          'owner'   => 'root',
          'group'   => 'foreman',
          'mode'    => '0640',
          'content' => /adapter: postgresql/,
        })
      end

      it 'should set the defaults file' do
        should contain_file('/etc/sysconfig/foreman').
          with_content(/^FOREMAN_HOME=\/usr\/share\/foreman$/).
          with_content(/^FOREMAN_USER=foreman$/).
          with_content(/^FOREMAN_ENV=production/).
          with_content(/^FOREMAN_USE_PASSENGER=1$/).
          with_ensure('file')
      end

      it { should contain_file('/usr/share/foreman').with_ensure('directory') }

      it { should contain_user('foreman').with({
        'ensure'  => 'present',
        'shell'   => '/bin/false',
        'comment' => 'Foreman',
        'gid'     => 'foreman',
        'groups'  => ['puppet'],
        'home'    => '/usr/share/foreman',
      })}

      it 'should remove old crons' do
        should contain_cron('clear_session_table').with_ensure('absent')
        should contain_cron('expire_old_reports').with_ensure('absent')
        should contain_cron('daily summary').with_ensure('absent')
      end

      it 'should contain foreman::config::passenger' do
        should contain_class('foreman::config::passenger').
          with_listen_on_interface(nil).
          with_ruby('/usr/bin/ruby193-ruby').
          that_comes_before('Anchor[foreman::config_end]')
      end

      it { should contain_apache__vhost('foreman').without_custom_fragment(/Alias/) }
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
          oauth_map_users       => true,
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
          with_content(/^:oauth_map_users:\s*true$/).
          with_content(/^:oauth_consumer_key:\s*abc$/).
          with_content(/^:oauth_consumer_secret:\s*def$/).
          with({})
      end
    end

    describe 'with url ending with trailing slash' do
      let :pre_condition do
        "class {'foreman':
          foreman_url => 'https://example.com/',
        }"
      end

      it { should contain_apache__vhost('foreman').without_custom_fragment(/Alias/) }
    end

    describe 'with sub-uri' do
      let :pre_condition do
        "class {'foreman':
          foreman_url => 'https://example.com/foreman',
        }"
      end

      it { should contain_apache__vhost('foreman').with_custom_fragment(/Alias \/foreman/) }
    end

    describe 'with sub-uri ending with trailing slash' do
      let :pre_condition do
        "class {'foreman':
          foreman_url => 'https://example.com/foreman/',
        }"
      end

      it { should contain_apache__vhost('foreman').with_custom_fragment(/Alias \/foreman/) }
    end

    describe 'with sub-uri ending with more levels' do
      let :pre_condition do
        "class {'foreman':
          foreman_url => 'https://example.com/apps/foreman/',
        }"
      end

      it { should contain_apache__vhost('foreman').with_custom_fragment(/Alias \/apps\/foreman/) }
    end

    describe 'with mysql db_type' do
      let :pre_condition do
        "class { 'foreman':
          db_type => 'mysql',
        }"
      end

      it 'should configure the mysql database' do
        should contain_file('/etc/foreman/database.yml').with_content(/adapter: mysql2/)
      end
    end
  end

  context 'on debian' do
    let :facts do
      default_facts.merge({
        :operatingsystem        => 'Debian',
        :operatingsystemrelease => 'wheezy',
        :osfamily               => 'Debian',
      })
    end

    describe 'without parameters' do
      let :pre_condition do
        "class {'foreman':}"
      end

      it 'should set up settings.yaml' do
        should contain_concat_build('foreman_settings').with_order(['*.yaml'])

        should contain_concat_fragment('foreman_settings+01-header.yaml').
          with_content(/^:unattended:\s*true$/).
          with_content(/^:login:\s*true$/).
          with_content(/^:require_ssl:\s*true$/).
          with_content(/^:locations_enabled:\s*false$/).
          with_content(/^:organizations_enabled:\s*false$/).
          with_content(/^:oauth_active:\s*true$/).
          with_content(/^:oauth_map_users:\s*false$/).
          with_content(/^:oauth_consumer_key:\s*\w+$/).
          with_content(/^:oauth_consumer_secret:\s*\w+$/).
          with({})

        should contain_file('/etc/foreman/settings.yaml').with({
          'source'  => %r{/concat_native/output/foreman_settings.out$},
          'require' => 'Concat_build[foreman_settings]',
          'owner'   => 'root',
          'group'   => 'foreman',
          'mode'    => '0640',
        })
      end

      it 'should configure the database' do
        should contain_file('/etc/foreman/database.yml').with({
          'owner'   => 'root',
          'group'   => 'foreman',
          'mode'    => '0640',
          'content' => /adapter: postgresql/,
        })
      end

      it 'should set the defaults file' do
        should contain_file('/etc/default/foreman').
          with_content(/^START=no$/).
          with_content(/^FOREMAN_HOME=\/usr\/share\/foreman$/).
          with_content(/^FOREMAN_USER=foreman$/).
          with_content(/^FOREMAN_ENV=production/).
          with_ensure('file')
      end

      it { should contain_file('/usr/share/foreman').with_ensure('directory') }

      it { should contain_user('foreman').with({
        'ensure'  => 'present',
        'shell'   => '/bin/false',
        'comment' => 'Foreman',
        'gid'     => 'foreman',
        'groups'  => ['puppet'],
        'home'    => '/usr/share/foreman',
      })}

      it 'should remove old crons' do
        should contain_cron('clear_session_table').with_ensure('absent')
        should contain_cron('expire_old_reports').with_ensure('absent')
        should contain_cron('daily summary').with_ensure('absent')
      end

      it { should contain_class('foreman::config::passenger').with({
        :listen_on_interface => nil,
        :ruby                => nil,
      })}
    end
  end
end
