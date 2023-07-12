require 'spec_helper'

describe 'foreman' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) { override_facts(facts, processors: { count: 3 }, memory: { system: { total_bytes:  10_737_418_240}}) }
      let(:params) { {} }
      let(:apache_user) { facts[:osfamily] == 'Debian' ? 'www-data' : 'apache' }

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
            .with_content(/^\s+:layout:\s+multiline_request_pattern$/)
            .with_content(/^:hsts_enabled:\s*true$/)

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

        it { should contain_systemd__dropin_file('foreman-socket').with_ensure('present') }
        it { should contain_systemd__dropin_file('foreman-service') }

        it { should contain_file('/usr/share/foreman').with_ensure('directory') }

        it {
          should contain_user('foreman').with(
            'ensure' => 'present',
            'shell' => %r{^(/usr)?/sbin/nologin$},
            'comment' => 'Foreman',
            'gid' => 'foreman',
            'groups' => ['puppet'],
            'home' => '/usr/share/foreman'
          )
        }

        # apache
        it 'should contain foreman::config::apache' do
          should contain_class('foreman::config::apache')
            .with_keycloak(false)
        end

        it do
          should contain_concat__fragment('foreman_settings+03-reverse-proxy-headers.yaml')
            .with_content(/^:ssl_client_dn_env: HTTP_SSL_CLIENT_S_DN$/)
            .with_content(/^:ssl_client_verify_env: HTTP_SSL_CLIENT_VERIFY$/)
            .with_content(/^:ssl_client_cert_env: HTTP_SSL_CLIENT_CERT$/)
        end

        it 'overrides foreman.socket systemd service' do
          should contain_systemd__dropin_file('foreman-socket')
            .with_ensure('present')
            .with_filename('installer.conf')
            .with_unit('foreman.socket')
            .with_content(%r{^ListenStream=/run/foreman\.sock$})
            .with_content(/^SocketUser=#{apache_user}$/)
        end

        it 'overrides foreman.service systemd service' do
          should contain_systemd__dropin_file('foreman-service')
            .with_ensure('present')
            .with_filename('installer.conf')
            .with_unit('foreman.service')
            .with_content(%r{^User=foreman$})
            .with_content(%r{^Environment=FOREMAN_ENV=production$})
            .with_content(%r{^Environment=FOREMAN_HOME=/usr/share/foreman$})
            .with_content(%r{^Environment=FOREMAN_PUMA_THREADS_MIN=5$})
            .with_content(%r{^Environment=FOREMAN_PUMA_THREADS_MAX=5$})
            .with_content(%r{^Environment=FOREMAN_PUMA_WORKERS=4$})
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

        # jobs
        it { should contain_class('redis') }
        it { should contain_redis__instance('default') }
        it { should contain_file('/etc/foreman/dynflow').with_ensure('directory') }
        it {
          should contain_foreman__dynflow__worker('orchestrator')
            .with_ensure('present')
            .with_concurrency(1)
            .with_queues(['dynflow_orchestrator'])
        }
        it {
          is_expected.to contain_service('postgresqld')
            .that_notifies('Service[dynflow-sidekiq@orchestrator]')
        }
        it { should contain_foreman__dynflow__worker('worker').with_ensure('absent') }
        it do
          should contain_foreman__dynflow__worker('worker-1')
            .with_ensure('present')
            .with_concurrency(5)
            .with_queues([['default', 1], ['remote_execution', 1]])
        end

        # service
        it { should contain_class('foreman::service') }
        it { should contain_service('foreman') }
        it { is_expected.to contain_service('dynflow-sidekiq@orchestrator').with_ensure('running').with_enable(true).that_requires('Class[redis]') }
        it { is_expected.to contain_service('dynflow-sidekiq@worker-1').with_ensure('running').with_enable(true).that_requires('Class[redis]') }

        # settings
        it { should contain_class('foreman::settings').that_requires('Class[foreman::database]') }

        # restart service when new plugins are installed
        it { should contain_file('/usr/share/foreman/tmp/restart_required_changed_plugins').that_requires('Class[foreman::install]').that_notifies('Class[foreman::service]') }
      end

      context 'without apache' do
        let(:params) { super().merge(apache: false) }

        it { should compile.with_all_deps }
        it { should_not contain_class('foreman::config::apache') }
        it { should_not contain_concat__fragment('foreman_settings+03-reverse-proxy-headers.yaml') }
        it { should contain_package('foreman-service').with_ensure('present') }
        it 'removes foreman.socket systemd override' do
          should contain_systemd__dropin_file('foreman-socket')
            .with_ensure('absent')
            .with_filename('installer.conf')
            .with_unit('foreman.socket')
            .without_content
        end
        it { should contain_systemd__dropin_file('foreman-service').with_filename('installer.conf').with_unit('foreman.service') }
        it { should contain_service('foreman').with_ensure('running') }
      end

      describe 'with all parameters' do
        let :params do
          {
            foreman_url: 'http://localhost',
            unattended: true,
            servername: 'localhost',
            serveraliases: ['foreman'],
            ssl: true,
            version: '1.12',
            plugin_version: 'installed',
            db_manage: true,
            db_host: 'db.example.com',
            db_port: 5432,
            db_database: 'somedb',
            db_username: 'foreman',
            db_password: 'secret',
            db_sslmode: 'prefer',
            db_pool: 5,
            db_manage_rake: true,
            server_port: 80,
            server_ssl_port: 443,
            server_ssl_ca: '/etc/ssl/certs/ca.pem',
            server_ssl_chain: '/etc/ssl/certs/ca.pem',
            server_ssl_cert: '/etc/ssl/certs/snakeoil.pem',
            server_ssl_key: '/etc/ssl/private/snakeoil.pem',
            server_ssl_crl: '/etc/ssl/certs/ca/crl.pem',
            server_ssl_protocol: '-all +TLSv1.2',
            client_ssl_ca: '/etc/ssl/certs/ca.pem',
            client_ssl_cert: '/etc/ssl/certs/snakeoil.pem',
            client_ssl_key: '/etc/ssl/private/key.pem',
            oauth_active: true,
            oauth_map_users: false,
            oauth_consumer_key: 'random',
            oauth_consumer_secret: 'random',
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
            email_sendmail_location: '/usr/bin/mysendmail',
            email_sendmail_arguments: '--myargument',
            email_smtp_address: 'smtp.example.com',
            email_smtp_port: 25,
            email_smtp_domain: 'example.com',
            email_smtp_authentication: 'none',
            email_smtp_user_name: 'root',
            email_smtp_password: 'secret',
            email_reply_address: 'noreply@foreman.domain',
            email_subject_prefix: '[prefix]',
            keycloak: true,
            keycloak_app_name: 'cloak-app',
            keycloak_realm: 'myrealm',
          }
        end

        it { is_expected.to compile.with_all_deps }
        it { should contain_package('foreman-postgresql').with_ensure('1.12') }
        it { should contain_package('foreman-service').with_ensure('1.12') }
        it { should contain_package('foreman-dynflow-sidekiq').with_ensure('1.12') }
        it do
          is_expected.to contain_class('foreman::config::apache')
            .with_keycloak(true)
            .with_keycloak_app_name('cloak-app')
            .with_keycloak_realm('myrealm')
        end

        it 'should configure certificates in settings.yaml' do
          is_expected.to contain_concat__fragment('foreman_settings+01-header.yaml')
            .with_content(%r{^:email_sendmail_location: "/usr/bin/mysendmail"$})
            .with_content(%r{^:email_sendmail_arguments: "--myargument"$})
            .with_content(%r{^:websockets_ssl_key: /etc/ssl/private/snakeoil-ws\.pem$})
            .with_content(%r{^:websockets_ssl_cert: /etc/ssl/certs/snakeoil-ws\.pem$})
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
                                            '    :layout: pattern'
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
        let(:params) { super().merge(rails_cache_store: { type: "redis" }) }
        it 'should set rails_cache_store config' do
          should contain_concat__fragment('foreman_settings+01-header.yaml')
            .with_content(%r{^:rails_cache_store:\n\s+:type:\s*redis\n\s+:urls:\n\s*- redis://localhost:6379/0\n\s+:options:\n\s+:compress:\s*true\n\s+:namespace:\s*foreman$})
        end
        it { is_expected.to contain_package('foreman-redis') }

        describe 'without dynflow managing redis' do
          let(:params) { super().merge(dynflow_manage_services: false) }

          it { is_expected.to contain_class('redis') }
        end
      end

      describe 'with rails_cache_store redis with explicit URL' do
        let(:params) { super().merge(rails_cache_store: { type: "redis", urls: [ "redis.example.com/0" ]}) }
        it 'should set rails_cache_store config' do
          should contain_concat__fragment('foreman_settings+01-header.yaml')
            .with_content(/^:rails_cache_store:\n\s+:type:\s*redis\n\s+:urls:\n\s*- redis:\/\/redis.example.com\/0\n\s+:options:\n\s+:compress:\s*true\n\s+:namespace:\s*foreman$/)
        end
        it { is_expected.to contain_package('foreman-redis') }

        describe 'without dynflow managing redis' do
          let(:params) { super().merge(dynflow_manage_services: false) }

          it { is_expected.not_to contain_class('redis') }
        end
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

      describe 'with trusted proxies' do
        let(:params) { super().merge(trusted_proxies: ['10.0.0.0/8', '127.0.0.1/32', '::1']) }
        it 'should set trusted proxies config' do
          should contain_concat__fragment('foreman_settings+01-header.yaml').
            with_content(/^:trusted_proxies:\n\s+- '10\.0\.0\.0\/8'\n\s+- '127\.0\.0\.1\/32'\n\s+- '::1'\n$/)
        end
      end

      context 'with email configured for SMTP' do
        let(:params) { super().merge(email_delivery_method: 'smtp') }

        it { should contain_foreman_config_entry('delivery_method').with_value('smtp') }
        it { should contain_foreman_config_entry('smtp_authentication').with_value('') }

        describe 'with email configured and authentication set to login' do
          let(:params) { super().merge(email_smtp_authentication: 'login') }
          it { should contain_foreman_config_entry('smtp_authentication').with_value('login') }
        end
      end

      describe 'with email configured for sendmail' do
        let(:params) { super().merge(email_delivery_method: 'sendmail') }
        it { should contain_foreman_config_entry('delivery_method').with_value('sendmail') }

        describe 'with sample parameters' do
          let(:params) do
            super().merge(
              email_smtp_address: 'smtp.example.com',
              email_smtp_port: 25,
              email_smtp_domain: 'example.com',
              email_smtp_authentication: 'none',
              email_smtp_user_name: 'smtp-username',
              email_smtp_password: 'smtp-password',
              email_reply_address: 'noreply@foreman.domain',
              email_subject_prefix: '[prefix]'
            )
          end

          it { should contain_foreman_config_entry('delivery_method').with_value('sendmail') }
          it { should contain_foreman_config_entry('smtp_address').with_value('smtp.example.com') }
          it { should contain_foreman_config_entry('smtp_port').with_value('25') }
          it { should contain_foreman_config_entry('smtp_domain').with_value('example.com') }
          it { should contain_foreman_config_entry('smtp_authentication').with_value('') }
          it { should contain_foreman_config_entry('smtp_user_name').with_value('smtp-username') }
          it { should contain_foreman_config_entry('smtp_password').with_value('smtp-password') }
          it { should contain_foreman_config_entry('email_reply_address').with_value('noreply@foreman.domain') }
          it { should contain_foreman_config_entry('email_subject_prefix').with_value('[prefix]') }
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
          let(:params) { super().merge(dynflow_redis_url: 'redis://127.0.0.1:4333/') }
          it { should_not contain_class('redis') }
          it { should_not contain_class('redis::instance') }
        end
      end

      describe 'with non-Puppet SSL certificates' do
        let(:params) do
          super().merge(
            server_ssl_key: '/etc/pki/localhost.key',
            server_ssl_cert: '/etc/pki/localhost.crt',
            client_ssl_key: '/etc/pki/localhost.key',
            client_ssl_cert: '/etc/pki/localhost.crt',
          )
        end

        it { should contain_user('foreman').with('groups' => []) }
      end
    end
  end
end
