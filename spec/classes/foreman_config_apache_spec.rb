require 'spec_helper'

describe 'foreman::config::apache' do
  on_os_under_test.each do |os, facts|
    context "on #{os}" do
      let(:facts) { facts }
      let(:params) do
        {
          app_root: '/usr/share/foreman',
          listen_on_interface: '192.168.0.1',
          ruby: '/usr/bin/tfm-ruby',
          priority: '05',
          servername: facts[:fqdn],
          serveraliases: ['foreman', 'also.foreman'],
          ssl: false,
          ssl_cert: '/cert.pem',
          ssl_certs_dir: '',
          ssl_key: '/key.pem',
          ssl_ca: '/ca.pem',
          ssl_chain: '/chain.pem',
          ssl_crl: '/crl.pem',
          ssl_protocol: '-all +TLSv1.2',
          user: 'foreman',
          prestart: true,
          min_instances: 1,
          start_timeout: 90,
          foreman_url: "https://#{facts[:fqdn]}",
          keepalive: true,
          max_keepalive_requests: 100,
          keepalive_timeout: 5,
          server_port: 80,
          server_ssl_port: 443,
          ipa_authentication: false
        }
      end

      let(:http_dir) do
        case facts[:osfamily]
        when 'RedHat'
          '/etc/httpd'
        when 'Debian'
          '/etc/apache2'
        end
      end

      describe 'with minimal parameters' do
        it 'should include apache with modules' do
          should contain_class('apache')
          should contain_class('apache::mod::headers')
          should contain_class('apache::mod::passenger')
        end

        it 'should ensure ownership' do
          should contain_file('/usr/share/foreman/config.ru').with_owner('foreman')
          should contain_file('/usr/share/foreman/config/environment.rb').with_owner('foreman')
        end
      end

      describe 'with ssl' do
        let(:params) { super().merge(ssl: true) }


        it 'should not contain the docroot' do
          should_not contain_file('/usr/share/foreman/public')
        end

        it 'should contain virt host plugin dir' do
          should contain_file("#{http_dir}/conf.d/05-foreman.d").with_ensure('directory')
        end

        it 'should contain ssl virt host plugin dir' do
          should contain_file("#{http_dir}/conf.d/05-foreman-ssl.d").with_ensure('directory')
        end

        it 'should include a http vhost' do
          should contain_apache__vhost('foreman')
            .with_ip(nil)
            .with_servername(facts[:fqdn])
            .with_serveraliases(['foreman', 'also.foreman'])
            .with_add_default_charset('UTF-8')
            .with_docroot('/usr/share/foreman/public')
            .with_priority('05')
            .with_options(['SymLinksIfOwnerMatch'])
            .with_port(80)
            .with_passenger_min_instances(1)
            .with_passenger_pre_start("http://#{facts[:fqdn]}:80")
            .with_passenger_start_timeout(90)
            .with_passenger_ruby('/usr/bin/tfm-ruby')
            .with_keepalive('on')
            .with_max_keepalive_requests(100)
            .with_keepalive_timeout(5)
            .with_custom_fragment(%r{^<Directory ~ /usr/share/foreman/public/\(assets\|webpack\)>$})
        end

        it 'should include a https vhost' do
          should contain_apache__vhost('foreman-ssl')
            .with_ip(nil)
            .with_servername(facts[:fqdn])
            .with_serveraliases(['foreman', 'also.foreman'])
            .with_add_default_charset('UTF-8')
            .with_docroot('/usr/share/foreman/public')
            .with_priority('05')
            .with_options(['SymLinksIfOwnerMatch'])
            .with_port(443)
            .with_passenger_min_instances(1)
            .with_passenger_pre_start("https://#{facts[:fqdn]}:443")
            .with_passenger_start_timeout(90)
            .with_passenger_ruby('/usr/bin/tfm-ruby')
            .with_ssl(true)
            .with_ssl_cert('/cert.pem')
            .with_ssl_certs_dir('')
            .with_ssl_key('/key.pem')
            .with_ssl_chain('/chain.pem')
            .with_ssl_ca('/ca.pem')
            .with_ssl_crl('/crl.pem')
            .with_ssl_protocol('-all +TLSv1.2')
            .with_ssl_verify_client('optional')
            .with_ssl_options('+StdEnvVars +ExportCertData')
            .with_ssl_verify_depth('3')
            .with_ssl_crl_check('chain')
            .with_keepalive('on')
            .with_max_keepalive_requests(100)
            .with_keepalive_timeout(5)
            .with_custom_fragment(%r{^<Directory ~ /usr/share/foreman/public/\(assets\|webpack\)>$})
        end

        describe 'with vhost and ssl, no CRL explicitly' do
          let :params do
            super().merge(
              ssl_certs_dir: '',
              ssl_crl: ''
            )
          end

          it do
            should contain_apache__vhost('foreman-ssl').without_ssl_crl
            should contain_apache__vhost('foreman-ssl').without_ssl_crl_chain
          end
        end

        describe 'with keepalive parameters set' do
          let :params do
            super().merge(
              keepalive: false,
              max_keepalive_requests: 10,
              keepalive_timeout: 15,
            )
          end

          it 'should set the respective parameters' do
            should contain_apache__vhost('foreman').with_keepalive('off')
            should contain_apache__vhost('foreman').with_max_keepalive_requests(10)
            should contain_apache__vhost('foreman').with_keepalive_timeout(15)
            should contain_apache__vhost('foreman-ssl').with_keepalive('off')
            should contain_apache__vhost('foreman-ssl').with_max_keepalive_requests(10)
            should contain_apache__vhost('foreman-ssl').with_keepalive_timeout(15)
          end
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
          let :params do
            super().merge(
              server_port: 8080,
              server_ssl_port: 8443,
            )
          end

          it 'should set the respective parameters' do
            should contain_apache__vhost('foreman').with_port(8080)
            should contain_apache__vhost('foreman').with_passenger_pre_start("http://#{facts[:fqdn]}:8080")
            should contain_apache__vhost('foreman-ssl').with_port(8443)
            should contain_apache__vhost('foreman-ssl').with_passenger_pre_start("https://#{facts[:fqdn]}:8443")
          end
        end
      end
    end
  end
end
