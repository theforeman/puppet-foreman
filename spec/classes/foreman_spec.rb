require 'spec_helper'

describe 'foreman' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) { facts }
      let(:params) { {} }

      context 'with default parameters' do
        it { is_expected.to compile.with_all_deps }

        # install
        it { should contain_class('foreman::install') }
        it { should contain_package('foreman-postgresql').with_ensure('present') }
        it { should_not contain_package('foreman-journald') }
        it { should contain_package('foreman-service') }

        # config
        it do
          is_expected.to contain_class('foreman::config')
            .that_notifies(['Class[foreman::database]', 'Class[foreman::service]'])
        end

        it 'should set up the config' do
          should contain_concat__fragment('foreman_settings+01-header.yaml')
            .with_content(/^:unattended:\s*true$/)
            .without_content(/^:unattended_url:/)
            .with_content(/^:require_ssl:\s*true$/)
            .with_content(/^:oauth_active:\s*true$/)
            .with_content(/^:oauth_map_users:\s*false$/)
            .with_content(/^:oauth_consumer_key:\s*\w+$/)
            .with_content(/^:oauth_consumer_secret:\s*\w+$/)
            .with_content(/^:websockets_encrypt:\s*true$/)
            .with_content(%r{^:websockets_ssl_key:\s*/etc/puppetlabs/puppet/ssl/private_keys/foo\.example\.com\.pem$})
            .with_content(%r{^:websockets_ssl_cert:\s*/etc/puppetlabs/puppet/ssl/certs/foo\.example\.com\.pem$})
            .with_content(%r{^:ssl_certificate:\s*/etc/puppetlabs/puppet/ssl/certs/foo\.example\.com\.pem$})
            .with_content(%r{^:ssl_ca_file:\s*/etc/puppetlabs/puppet/ssl/certs/ca.pem$})
            .with_content(%r{^:ssl_priv_key:\s*/etc/puppetlabs/puppet/ssl/private_keys/foo\.example\.com\.pem$})
            .with_content(/^:logging:\n\s*:level:\s*info$/)
            .with_content(/^:dynflow:\n\s*:pool_size:\s*5$/)
            .with_content(/^:hsts_enabled:\s*true$/)
            .with_content(/^:ssl_client_dn_env:/)
            .with_content(/^:ssl_client_verify_env:/)
            .with_content(/^:ssl_client_cert_env:/)

          should contain_concat('/etc/foreman/settings.yaml')
            .with_owner('root')
            .with_group('foreman')
            .with_mode('0640')
        end

        it 'should configure the database' do
          should contain_file('/etc/foreman/database.yml')
            .with_owner('root')
            .with_group('foreman')
            .with_mode('0640')
            .with_content(/adapter: postgresql/)
        end

        it { should contain_systemd__dropin_file('foreman-socket') }
        it { should contain_systemd__dropin_file('foreman-service') }

        it { should contain_file('/usr/share/foreman').with_ensure('directory') }

        it {
          should contain_user('foreman').with(
            'ensure' => 'present',
            'shell' => '/bin/false',
            'comment' => 'Foreman',
            'gid' => 'foreman',
            'groups' => ['puppet'],
            'home' => '/usr/share/foreman'
          )
        }

        it 'should remove old crons' do
          should contain_cron('clear_session_table').with_ensure('absent')
          should contain_cron('expire_old_reports').with_ensure('absent')
          should contain_cron('daily summary').with_ensure('absent')
        end

        it 'should contain foreman::config::apache' do
          passenger_ruby = if facts[:osfamily] == 'RedHat' && facts[:os]['release']['major'] == '7'
                             '/usr/bin/tfm-ruby'
                           elsif facts[:osfamily] == 'Debian'
                             '/usr/bin/foreman-ruby'
                           end

          should contain_class('foreman::config::apache')
            .with_passenger_ruby(passenger_ruby)
            .with_keycloak(false)
        end

        it { should contain_apache__vhost('foreman').without_custom_fragment(/Alias/) }

        it 'should not integrate ipa' do
          should_not contain_exec('ipa-getkeytab')
        end

        # database
        it {
          should contain_class('foreman::database')
            .that_comes_before('Class[apache::service]')
            .that_notifies('Class[foreman::service]')
        }
        it {
          should contain_class('foreman::database::postgresql')
            .that_notifies('Foreman::Rake[db:migrate]')
        }

        it { should contain_foreman__rake('db:migrate') }
        it { should contain_foreman_config_entry('db_pending_seed') }
        it { should contain_foreman__rake('db:seed') }
        it { should contain_foreman__rake('apipie:cache:index') }
        it { should contain_foreman__rake('apipie_dsl:cache') }

        # jobs
        it { should contain_class('redis') }
        it { should contain_redis__instance('default') }
        it { should contain_file('/etc/foreman/dynflow').with_ensure('directory') }
        it {
          should contain_foreman__dynflow__worker('orchestrator')
            .with_concurrency(1)
            .with_queues(['dynflow_orchestrator'])
        }
        it { should contain_foreman__dynflow__worker('worker') }

        # service
        it { should contain_class('foreman::service') }
        it { should contain_service('foreman') }
        it { is_expected.to contain_service('dynflow-sidekiq@orchestrator').with_ensure('running').with_enable(true) }
        it { is_expected.to contain_service('dynflow-sidekiq@worker').with_ensure('running').with_enable(true) }

        # settings
        it { should contain_class('foreman::settings').that_requires('Class[foreman::database]') }
      end

      context 'with passenger' do
        let(:params) { super().merge(passenger: true) }

        it { should_not contain_systemd__dropin_file('foreman-socket') }
        it { should_not contain_systemd__dropin_file('foreman-service') }
        it do
          should contain_exec('restart_foreman')
            .with_command('/bin/touch /usr/share/foreman/tmp/restart.txt')
            .with_refreshonly(true)
            .with_cwd('/usr/share/foreman')
            .with_path('/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin')
        end
      end

      context 'without passenger' do
        let(:params) { super().merge(passenger: false) }

        it { should compile.with_all_deps }
        it { should contain_class('foreman::config::apache').with_passenger(false) }
        it { should contain_systemd__dropin_file('foreman-socket').with_filename('installer.conf').with_unit('foreman.socket').with_content(/^ListenStream=\/run\/foreman\.sock$/) }
        it { should contain_systemd__dropin_file('foreman-service').with_filename('installer.conf').with_unit('foreman.service').with_content(/^Environment=FOREMAN_BIND=unix:\/\/\/run\/foreman\.sock$/) }
        it do
          should contain_concat__fragment('foreman_settings+01-header.yaml')
            .with_content(/^:ssl_client_dn_env: HTTP_SSL_CLIENT_S_DN$/)
            .with_content(/^:ssl_client_verify_env: HTTP_SSL_CLIENT_VERIFY$/)
            .with_content(/^:ssl_client_cert_env: HTTP_SSL_CLIENT_CERT$/)
        end
      end

      context 'without apache' do
        let(:params) { super().merge(apache: false) }

        it { should compile.with_all_deps }
        it { should_not contain_class('foreman::config::apache') }
        it { should contain_package('foreman-service').with_ensure('installed') }
        it { should contain_systemd__dropin_file('foreman-socket').with_filename('installer.conf').with_unit('foreman.socket').with_content(/^ListenStream=0\.0\.0\.0:3000$/) }
        it { should contain_systemd__dropin_file('foreman-service').with_filename('installer.conf').with_unit('foreman.service') }
        it { should contain_service('foreman').with_ensure('running') }
        it { should_not contain_exec('restart_foreman') }
      end

      describe 'with all parameters' do
        let :params do
          {
            foreman_url: 'http://localhost',
            unattended: true,
            passenger: true,
            passenger_ruby: '/usr/bin/ruby',
            passenger_ruby_package: 'ruby-gem-passenger',
            plugin_prefix: 'ruby-foreman',
            servername: 'localhost',
            serveraliases: ['foreman'],
            ssl: true,
            version: '1.12',
            plugin_version: 'installed',
            db_manage: true,
            db_host: 'UNSET',
            db_port: 'UNSET',
            db_database: 'UNSET',
            db_username: 'foreman',
            db_password: 'secret',
            db_sslmode: 'UNSET',
            db_pool: 5,
            db_manage_rake: true,
            app_root: '/usr/share/foreman',
            manage_user: false,
            user: 'foreman',
            group: 'foreman',
            user_groups: %w[adm wheel],
            rails_env: 'production',
            vhost_priority: '5',
            server_port: 80,
            server_ssl_port: 443,
            server_ssl_ca: '/etc/ssl/certs/ca.pem',
            server_ssl_chain: '/etc/ssl/certs/ca.pem',
            server_ssl_cert: '/etc/ssl/certs/snakeoil.pem',
            server_ssl_certs_dir: '/etc/ssl/certs/',
            server_ssl_key: '/etc/ssl/private/snakeoil.pem',
            server_ssl_crl: '/etc/ssl/certs/ca/crl.pem',
            server_ssl_protocol: '-all +TLSv1.2',
            server_ca_file_configure: true,
            client_ssl_ca: '/etc/ssl/certs/ca.pem',
            client_ssl_cert: '/etc/ssl/certs/snakeoil.pem',
            client_ssl_key: '/etc/ssl/private/key.pem',
            oauth_active: true,
            oauth_map_users: false,
            oauth_consumer_key: 'random',
            oauth_consumer_secret: 'random',
            passenger_prestart: false,
            passenger_min_instances: 3,
            passenger_start_timeout: 20,
            initial_admin_username: 'admin',
            initial_admin_password: 'secret',
            initial_admin_first_name: 'Alice',
            initial_admin_last_name: 'Bob',
            initial_admin_email: 'alice@bob.com',
            initial_admin_locale: 'en_GB',
            initial_admin_timezone: 'Hawaii',
            initial_organization: 'acme',
            initial_location: 'acme',
            ipa_authentication: false,
            http_keytab: '/etc/httpd/conf.keytab',
            pam_service: 'foreman',
            ipa_manage_sssd: true,
            websockets_encrypt: true,
            websockets_ssl_key: '/etc/ssl/private/snakeoil-ws.pem',
            websockets_ssl_cert: '/etc/ssl/certs/snakeoil-ws.pem',
            logging_level: 'info',
            loggers: {},
            email_delivery_method: 'sendmail',
            email_smtp_address: 'smtp.example.com',
            email_smtp_port: 25,
            email_smtp_domain: 'example.com',
            email_smtp_authentication: 'none',
            email_smtp_user_name: 'root',
            email_smtp_password: 'secret',
            keycloak: true,
            keycloak_app_name: 'cloak-app',
            keycloak_realm: 'myrealm',
          }
        end

        it { is_expected.to compile.with_all_deps }
        it do
          is_expected.to contain_class('foreman::config::apache')
            .with_keycloak(true)
            .with_keycloak_app_name('cloak-app')
            .with_keycloak_realm('myrealm')
        end

        it 'should configure certificates in settings.yaml' do
          is_expected.to contain_concat__fragment('foreman_settings+01-header.yaml')
            .with_content(%r{^:websockets_ssl_key: /etc/ssl/private/snakeoil-ws\.pem$})
            .with_content(%r{^:websockets_ssl_cert: /etc/ssl/certs/snakeoil-ws\.pem$})
            .with_content(%r{^:server_ca_file: /etc/ssl/certs/ca\.pem$})
        end
      end

      context 'with journald logging' do
        let(:params) { super().merge(logging_type: 'journald') }
        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_package('foreman-journald') }
        it 'should configure logging in settings.yaml' do
          verify_concat_fragment_contents(catalogue, 'foreman_settings+01-header.yaml', [
                                            ':logging:',
                                            '  :level: info',
                                            '  :production:',
                                            '    :type: journald',
                                            '    :layout: multiline_request_pattern'
                                          ])
        end
      end

      describe 'with different template parameters' do
        let :params do
          {
            unattended: false,
            ssl: false,
            oauth_active: false,
            oauth_map_users: true,
            oauth_consumer_key: 'abc',
            oauth_consumer_secret: 'def'
          }
        end

        it 'should have changed parameters' do
          should contain_concat__fragment('foreman_settings+01-header.yaml')
            .with_content(/^:unattended:\s*false$/)
            .with_content(/^:require_ssl:\s*false$/)
            .with_content(/^:oauth_active:\s*false$/)
            .with_content(/^:oauth_map_users:\s*true$/)
            .with_content(/^:oauth_consumer_key:\s*abc$/)
            .with_content(/^:oauth_consumer_secret:\s*def$/)
        end
      end

      describe 'with unattended_url' do
        let(:params) { super().merge(unattended_url: 'http://example.com') }
        it {
          should contain_concat__fragment('foreman_settings+01-header.yaml')
            .with_content(%r{^:unattended_url:\s*http://example.com$})
        }
      end

      context 'with passenger' do
        let(:params) { super().merge(passenger: true) }

        describe 'with url ending with trailing slash' do
          let(:params) { super().merge(foreman_url: 'https://example.com/') }
          it { should contain_apache__vhost('foreman').without_custom_fragment(/Alias/) }
        end

        describe 'with sub-uri' do
          let(:params) { super().merge(foreman_url: 'https://example.com/foreman') }
          it { should contain_apache__vhost('foreman').with_custom_fragment(%r{Alias /foreman}) }
        end

        describe 'with sub-uri ending with trailing slash' do
          let(:params) { super().merge(foreman_url: 'https://example.com/foreman/') }
          it { should contain_apache__vhost('foreman').with_custom_fragment(%r{Alias /foreman}) }
        end

        describe 'with sub-uri ending with more levels' do
          let(:params) { super().merge(foreman_url: 'https://example.com/apps/foreman/') }
          it { should contain_apache__vhost('foreman').with_custom_fragment(%r{Alias /apps/foreman}) }
        end
      end

      describe 'with loggers' do
        let(:params) { super().merge(loggers: { ldap: true }) }
        it 'should set loggers config' do
          should contain_concat__fragment('foreman_settings+01-header.yaml')
            .with_content(/^:loggers:\n\s+:ldap:\n\s+:enabled:\s*true$/)
        end
      end

      describe 'with rails_cache_store file' do
        let(:params) { super().merge(rails_cache_store: { type: "file" }) }
        it 'should set rails_cache_store config' do
          should contain_concat__fragment('foreman_settings+01-header.yaml')
            .with_content(/^:rails_cache_store:\n\s+:type:\s*file$/)
        end
      end

      describe 'with rails_cache_store redis' do
        let(:params) { super().merge(rails_cache_store: { type: "redis", urls: [ "redis.example.com/0" ]}) }
        it 'should set rails_cache_store config' do
          should contain_concat__fragment('foreman_settings+01-header.yaml')
            .with_content(/^:rails_cache_store:\n\s+:type:\s*redis\n\s+:urls:\n\s*- redis:\/\/redis.example.com\/0\n\s+:options:\n\s+:compress:\s*true\n\s+:namespace:\s*foreman$/)
        end
        it { is_expected.to contain_package('foreman-redis') }
      end

      describe 'with rails_cache_store redis with options' do
        let(:params) { super().merge(rails_cache_store: { type: "redis", urls: [ "redis.example.com/0", "redis2.example.com/0" ], options: {compress: "false", namespace: "katello"}}) }
        it 'should set rails_cache_store config' do
          should contain_concat__fragment('foreman_settings+01-header.yaml')
            .with_content(/^:rails_cache_store:\n\s+:type:\s*redis\n\s+:urls:\n\s*- redis:\/\/redis.example.com\/0\n\s*- redis:\/\/redis2.example.com\/0\n\s+:options:\n\s+:compress:\s*false\n\s+:namespace:\s*katello$/)
        end
        it { is_expected.to contain_package('foreman-redis') }
      end

      describe 'with cors domains' do
        let(:params) { super().merge(cors_domains: ['https://example.com']) }
        it 'should set cors config' do
          should contain_concat__fragment('foreman_settings+01-header.yaml').
            with_content(/^:cors_domains:\n\s+- 'https:\/\/example\.com'\n$/)
        end
      end

      context 'with email configured for SMTP' do
        let(:params) { super().merge(email_delivery_method: 'smtp') }

        it { should contain_file('/etc/foreman/email.yaml').with_ensure('absent') }
        it { should contain_foreman_config_entry('delivery_method').with_value('smtp') }
        it { should contain_foreman_config_entry('smtp_authentication').with_value('') }

        describe 'with email configured and authentication set to login' do
          let(:params) { super().merge(email_smtp_authentication: 'login') }
          it { should contain_foreman_config_entry('smtp_authentication').with_value('login') }
        end
      end

      describe 'with email configured for sendmail' do
        let(:params) { super().merge(email_delivery_method: 'sendmail') }
        it { should contain_file('/etc/foreman/email.yaml').with_ensure('absent') }
        it { should contain_foreman_config_entry('delivery_method').with_value('sendmail') }

        describe 'with sample parameters' do
          let(:params) do
            super().merge(
              email_smtp_address: 'smtp.example.com',
              email_smtp_port: 25,
              email_smtp_domain: 'example.com',
              email_smtp_authentication: 'none',
              email_smtp_user_name: 'smtp-username',
              email_smtp_password: 'smtp-password'
            )
          end

          it { should contain_foreman_config_entry('delivery_method').with_value('sendmail') }
          it { should contain_foreman_config_entry('smtp_address').with_value('smtp.example.com') }
          it { should contain_foreman_config_entry('smtp_port').with_value('25') }
          it { should contain_foreman_config_entry('smtp_domain').with_value('example.com') }
          it { should contain_foreman_config_entry('smtp_authentication').with_value('') }
          it { should contain_foreman_config_entry('smtp_user_name').with_value('smtp-username') }
          it { should contain_foreman_config_entry('smtp_password').with_value('smtp-password') }
        end

        context 'with email_smtp_authentication=cram-md5' do
          let(:params) { super().merge(email_smtp_authentication: 'cram-md5') }
          it { should contain_foreman_config_entry('smtp_authentication').with_value('cram-md5') }
        end
      end

      describe 'with registration' do
        let :pre_condition do
          <<-PUPPET
          foreman_smartproxy { 'sp.example.com':
            base_url => "https://${facts['fqdn']}",
          }
          PUPPET
        end
        it { is_expected.to compile.with_all_deps }
        it do
          is_expected.to contain_foreman_smartproxy('sp.example.com')
            .that_requires(['Class[Foreman::Service]', 'Service[httpd]'])
        end
      end

      describe 'with custom redis' do
        context 'with redis_url' do
          let(:params) { super().merge(jobs_sidekiq_redis_url: 'redis://127.0.0.1:4333/') }
          it { should_not contain_class('redis') }
          it { should_not contain_class('redis::instance') }
        end
      end
    end
  end
end
