require 'spec_helper'

describe 'foreman::config::apache' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) { facts }
      let(:params) { {} }

      let(:http_dir) do
        case facts[:os]['family']
        when 'RedHat'
          '/etc/httpd'
        when 'Debian'
          '/etc/apache2'
        end
      end

      let(:proxy_pass_params) do
        { 'retry' => '0', 'upgrade' => 'websocket' }
      end


      it { should compile.with_all_deps }

      it 'should include apache with modules' do
        should contain_class('apache::mod::env')
        should contain_apache__mod('expires')
        should contain_class('apache::mod::proxy')
        should contain_class('apache::mod::proxy_http')
        should contain_class('apache::mod::rewrite')
      end

      it 'does not manage the docroot' do
        should_not contain_file('/usr/share/foreman/public')
      end

      it 'creates a virtual host plugin dir for HTTP' do
        should contain_file("#{http_dir}/conf.d/05-foreman.d").with_ensure('directory')
      end

      it 'does not create a virtual host plugin dir for HTTPS' do
        should_not contain_file("#{http_dir}/conf.d/05-foreman-ssl.d")
      end

      it 'configures the HTTP vhost' do
        should contain_apache__vhost('foreman')
          .with_ip(nil)
          .with_servername(facts[:networking]['fqdn'])
          .with_serveraliases([])
          .with_add_default_charset('UTF-8')
          .with_docroot('/usr/share/foreman/public')
          .with_priority('05')
          .with_options(['SymLinksIfOwnerMatch'])
          .with_port(80)
          .with_custom_fragment(%r{^<LocationMatch "\^/\(assets\|webpack\)">$})
          .with_proxy_preserve_host(true)
          .with_proxy_add_headers(true)
          .with_request_headers([
            'set X-FORWARDED-PROTO "http"',
            'set SSL-CLIENT-S-DN ""',
            'set SSL-CLIENT-CERT ""',
            'set SSL-CLIENT-VERIFY ""',
            'unset REMOTE-USER',
            'unset REMOTE_USER',
            'unset REMOTE-USER-EMAIL',
            'unset REMOTE-USER_EMAIL',
            'unset REMOTE_USER-EMAIL',
            'unset REMOTE_USER_EMAIL',
            'unset REMOTE-USER-FIRSTNAME',
            'unset REMOTE-USER_FIRSTNAME',
            'unset REMOTE_USER-FIRSTNAME',
            'unset REMOTE_USER_FIRSTNAME',
            'unset REMOTE-USER-LASTNAME',
            'unset REMOTE-USER_LASTNAME',
            'unset REMOTE_USER-LASTNAME',
            'unset REMOTE_USER_LASTNAME',
            'unset REMOTE-USER-GROUPS',
            'unset REMOTE-USER_GROUPS',
            'unset REMOTE_USER-GROUPS',
            'unset REMOTE_USER_GROUPS'
          ])
          .with_proxy_pass(
            "no_proxy_uris" => ['/pulp', '/pub', '/icons', '/images', '/server-status', '/webpack', '/assets'],
            "path"          => '/',
            "url"           => 'unix:///run/foreman.sock|http://foreman/',
            "params"        => proxy_pass_params,
          )
      end

      it 'does not configure the HTTPS vhost' do
        should_not contain_apache__vhost('foreman-ssl')
      end

      describe 'with $apache::default_mods set to false' do
        let(:pre_condition) do
          <<~PUPPET
          class { 'apache':
            default_mods => false,
          }
          PUPPET
        end

        it { should compile.with_all_deps }
        it 'includes apache modules' do
          should contain_class('apache::mod::env')
          should contain_apache__mod('expires')
          should contain_class('apache::mod::proxy')
          should contain_class('apache::mod::proxy_http')
          should contain_class('apache::mod::rewrite')
        end
      end

      describe 'with keycloak' do
        let(:params) { super().merge(keycloak: true) }

        it { should compile.with_all_deps }
        it { should contain_class('apache::mod::auth_openidc') }
        it { should contain_file("#{http_dir}/conf.d/foreman-openidc_oidc_keycloak_ssl-realm.conf") }
      end

      describe 'with custom HTTP headers to unset' do
        let(:params) do
          super().merge(
            request_headers_to_unset: ['OIDC_FOO'],
          )
        end

        it { should contain_apache__vhost('foreman')
            .with_request_headers([
              'set X-FORWARDED-PROTO "http"',
              'set SSL-CLIENT-S-DN ""',
              'set SSL-CLIENT-CERT ""',
              'set SSL-CLIENT-VERIFY ""',
              'unset OIDC_FOO',
            ])
        }
      end

      describe 'with asset proxying enabled' do
        let(:params) do
          super().merge(
            proxy_assets: true
          )
        end

        it { should contain_apache__vhost('foreman')
            .with_proxy_pass(
              "no_proxy_uris" => ['/pulp', '/pub', '/icons', '/images', '/server-status'],
              "path"          => '/',
              "url"           => 'unix:///run/foreman.sock|http://foreman/',
              "params"        => proxy_pass_params,
            )
        }
      end

      describe 'with ssl' do
        let(:params) do
          {
            ssl: true,
            ssl_cert: '/cert.pem',
            ssl_key: '/key.pem',
            ssl_crl: '/crl.pem',
            ssl_chain: '/chain.pem',
            ssl_ca: '/ca.pem',
            ssl_protocol: '-all +TLSv1.2',
            ssl_verify_client: 'require',
          }
        end

        it 'creates a virtual host plugin dir for HTTPS' do
          should contain_file("#{http_dir}/conf.d/05-foreman-ssl.d").with_ensure('directory')
        end

        it 'should include a https vhost' do
          should contain_apache__vhost('foreman-ssl')
            .with_ip(nil)
            .with_servername(facts[:networking]['fqdn'])
            .with_serveraliases([])
            .with_add_default_charset('UTF-8')
            .with_docroot('/usr/share/foreman/public')
            .with_priority('05')
            .with_options(['SymLinksIfOwnerMatch'])
            .with_port(443)
            .with_ssl(true)
            .with_ssl_cert('/cert.pem')
            .with_ssl_certs_dir(nil)
            .with_ssl_key('/key.pem')
            .with_ssl_chain('/chain.pem')
            .with_ssl_ca('/ca.pem')
            .with_ssl_crl('/crl.pem')
            .with_ssl_protocol('-all +TLSv1.2')
            .with_ssl_verify_client('require')
            .with_ssl_options('+StdEnvVars +ExportCertData')
            .with_ssl_verify_depth('3')
            .with_ssl_crl_check('chain')
            .with_custom_fragment(%r{^<LocationMatch "\^/\(assets\|webpack\)">$})
            .with_proxy_preserve_host(true)
            .with_proxy_add_headers(true)
            .with_request_headers([
              'set X-FORWARDED-PROTO "https"',
              'set SSL-CLIENT-S-DN "%{SSL_CLIENT_S_DN}s"',
              'set SSL-CLIENT-CERT "%{SSL_CLIENT_CERT}s"',
              'set SSL-CLIENT-VERIFY "%{SSL_CLIENT_VERIFY}s"',
              'unset REMOTE-USER',
              'unset REMOTE_USER',
              'unset REMOTE-USER-EMAIL',
              'unset REMOTE-USER_EMAIL',
              'unset REMOTE_USER-EMAIL',
              'unset REMOTE_USER_EMAIL',
              'unset REMOTE-USER-FIRSTNAME',
              'unset REMOTE-USER_FIRSTNAME',
              'unset REMOTE_USER-FIRSTNAME',
              'unset REMOTE_USER_FIRSTNAME',
              'unset REMOTE-USER-LASTNAME',
              'unset REMOTE-USER_LASTNAME',
              'unset REMOTE_USER-LASTNAME',
              'unset REMOTE_USER_LASTNAME',
              'unset REMOTE-USER-GROUPS',
              'unset REMOTE-USER_GROUPS',
              'unset REMOTE_USER-GROUPS',
              'unset REMOTE_USER_GROUPS'
            ])
            .with_ssl_proxyengine(true)
            .with_proxy_pass(
              "no_proxy_uris" => ['/pulp', '/pub', '/icons', '/images', '/server-status', '/webpack', '/assets'],
              "path"          => '/',
              "url"           => 'unix:///run/foreman.sock|http://foreman/',
              "params"        => proxy_pass_params,
            )
        end

        describe 'with vhost and ssl, no CRL explicitly' do
          let(:params) do
            super().merge(
              ssl_crl: '',
            )
          end

          it { should contain_apache__vhost('foreman-ssl').without_ssl_crl.without_ssl_crl_chain }
        end

        describe 'with a different priority set' do
          let(:params) { super().merge(priority: '20') }

          it 'should contain virt host plugin dir' do
            should_not contain_file("#{http_dir}/conf.d/05-foreman.d")
            should contain_file("#{http_dir}/conf.d/20-foreman.d").with_ensure('directory')
          end

          it 'should contain ssl virt host plugin dir' do
            should_not contain_file("#{http_dir}/conf.d/05-foreman-ssl.d")
            should contain_file("#{http_dir}/conf.d/20-foreman-ssl.d").with_ensure('directory')
          end

          it 'should include a http vhost' do
            should contain_apache__vhost('foreman')
              .with_priority(20)
              .with_additional_includes(["#{http_dir}/conf.d/20-foreman.d/*.conf"])
          end

          it 'should include a http ssl vhost' do
            should contain_apache__vhost('foreman-ssl')
              .with_priority(20)
              .with_ssl(true)
              .with_additional_includes(["#{http_dir}/conf.d/20-foreman-ssl.d/*.conf"])
          end
        end

        describe 'with different ports set' do
          let(:params) do
            super().merge(
              server_port: 8080,
              server_ssl_port: 8443,
            )
          end

          it 'should set the respective parameters' do
            should contain_apache__vhost('foreman').with_port(8080)
            should contain_apache__vhost('foreman-ssl').with_port(8443)
          end
        end

        describe 'with vhost and ssl, custom HTTP headers to unset' do
          let(:params) do
            super().merge(
              request_headers_to_unset: ['OIDC_FOO'],
            )
          end

          it { should contain_apache__vhost('foreman-ssl')
              .with_request_headers([
                'set X-FORWARDED-PROTO "https"',
                'set SSL-CLIENT-S-DN "%{SSL_CLIENT_S_DN}s"',
                'set SSL-CLIENT-CERT "%{SSL_CLIENT_CERT}s"',
                'set SSL-CLIENT-VERIFY "%{SSL_CLIENT_VERIFY}s"',
                'unset OIDC_FOO',
              ])
          }
        end

        describe 'with proxy_add_headers to false' do
          let(:params) { super().merge(proxy_add_headers: false) }

          it 'all vhosts must have the setting' do
            should contain_apache__vhost('foreman')
              .with_proxy_add_headers(false)
            should contain_apache__vhost('foreman-ssl')
              .with_proxy_add_headers(false)
          end
        end
      end
    end
  end
end
