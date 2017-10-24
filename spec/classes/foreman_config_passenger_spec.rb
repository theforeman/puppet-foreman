require 'spec_helper'


describe 'foreman::config::passenger' do
  on_os_under_test.each do |os, facts|
    context "on #{os}" do
      let :facts do facts end

      describe 'with minimal parameters' do
        let :params do {
          :app_root               => '/usr/share/foreman',
          :use_vhost              => true,
          :listen_on_interface    => '192.168.0.1',
          :ruby                   => '/usr/bin/tfm-ruby',
          :priority               => '15',
          :servername             => facts[:fqdn],
          :serveraliases          => ['foreman'],
          :ssl                    => false,
          :ssl_cert               => '/cert.pem',
          :ssl_certs_dir          => '',
          :ssl_key                => '/key.pem',
          :ssl_ca                 => '/ca.pem',
          :ssl_chain              => '/ca.pem',
          :ssl_crl                => '/crl.pem',
          :ssl_protocol           => '-all +TLSv1.2',
          :user                   => 'foreman',
          :prestart               => true,
          :min_instances          => 1,
          :start_timeout          => 90,
          :foreman_url            => "https://#{facts[:fqdn]}",
          :keepalive              => true,
          :max_keepalive_requests => 100,
          :keepalive_timeout      => 5,
          :server_port            => 80,
          :server_ssl_port        => 443,
          :ipa_authentication     => false,
        } end

        it 'should include apache with modules' do
          should contain_class('apache')
          should contain_class('apache::mod::headers')
          should contain_class('apache::mod::passenger')
        end

        it 'should ensure ownership' do
          should contain_file("#{params[:app_root]}/config.ru").with_owner(params[:user])
          should contain_file("#{params[:app_root]}/config/environment.rb").with_owner(params[:user])
        end
      end

      describe 'with vhost and ssl' do
        let :params do {
          :app_root               => '/usr/share/foreman',
          :use_vhost              => true,
          :listen_on_interface    => '192.168.0.1',
          :priority               => '05',
          :servername             => facts[:fqdn],
          :serveraliases          => ['foreman', 'also.foreman'],
          :ssl                    => true,
          :ssl_cert               => '/cert.pem',
          :ssl_certs_dir          => '',
          :ssl_key                => '/key.pem',
          :ssl_ca                 => '/ca.pem',
          :ssl_chain              => '/ca.pem',
          :ssl_crl                => '/crl.pem',
          :ssl_protocol           => '-all +TLSv1.2',
          :user                   => 'foreman',
          :prestart               => true,
          :min_instances          => 1,
          :start_timeout          => 90,
          :ruby                   => '/usr/bin/tfm-ruby',
          :foreman_url            => "https://#{facts[:fqdn]}",
          :keepalive              => true,
          :max_keepalive_requests => 100,
          :keepalive_timeout      => 5,
          :server_port            => 80,
          :server_ssl_port        => 443,
          :ipa_authentication     => false,
        } end

        case facts[:osfamily]
        when 'RedHat'
          http_dir = '/etc/httpd'
        when 'Debian'
          http_dir = '/etc/apache2'
        end

        it 'should not contain the docroot' do
          should_not contain_file("#{params[:app_root]}/public")
        end

        it 'should contain virt host plugin dir' do
          should contain_file("#{http_dir}/conf.d/05-foreman.d").with_ensure('directory')
        end

        it 'should contain ssl virt host plugin dir' do
          should contain_file("#{http_dir}/conf.d/05-foreman-ssl.d").with_ensure('directory')
        end

        it 'should include a http vhost' do
          should contain_apache__vhost('foreman').with({
            :ip                      => nil,
            :servername              => facts[:fqdn],
            :serveraliases           => ['foreman', 'also.foreman'],
            :add_default_charset     => 'UTF-8',
            :docroot                 => "#{params[:app_root]}/public",
            :priority                => '05',
            :options                 => ['SymLinksIfOwnerMatch'],
            :port                    => 80,
            :passenger_min_instances => 1,
            :passenger_pre_start     => "http://#{facts[:fqdn]}:80",
            :passenger_start_timeout => 90,
            :passenger_ruby          => '/usr/bin/tfm-ruby',
            :keepalive               => 'on',
            :max_keepalive_requests  => 100,
            :keepalive_timeout       => 5,
            :custom_fragment         => %r{^<Directory ~ #{params[:app_root]}/public/\(assets\|webpack\)>$},
          })
        end

        it 'should include a https vhost' do
          should contain_apache__vhost('foreman-ssl').with({
            :ip                      => nil,
            :servername              => facts[:fqdn],
            :serveraliases           => ['foreman', 'also.foreman'],
            :add_default_charset     => 'UTF-8',
            :docroot                 => "#{params[:app_root]}/public",
            :priority                => '05',
            :options                 => ['SymLinksIfOwnerMatch'],
            :port                    => 443,
            :passenger_min_instances => 1,
            :passenger_pre_start     => "https://#{facts[:fqdn]}:443",
            :passenger_start_timeout => 90,
            :passenger_ruby          => '/usr/bin/tfm-ruby',
            :ssl                     => true,
            :ssl_cert                => params[:ssl_cert],
            :ssl_certs_dir           => params[:ssl_certs_dir],
            :ssl_key                 => params[:ssl_key],
            :ssl_chain               => params[:ssl_chain],
            :ssl_ca                  => params[:ssl_ca],
            :ssl_crl                 => params[:ssl_crl],
            :ssl_protocol            => '-all +TLSv1.2',
            :ssl_verify_client       => 'optional',
            :ssl_options             => '+StdEnvVars +ExportCertData',
            :ssl_verify_depth        => '3',
            :ssl_crl_check           => 'chain',
            :keepalive               => 'on',
            :max_keepalive_requests  => 100,
            :keepalive_timeout       => 5,
            :custom_fragment         => %r{^<Directory ~ #{params[:app_root]}/public/\(assets\|webpack\)>$},
          })
        end
      end

      describe 'with vhost and ssl, no CRL explicitly' do
        let :params do {
          :app_root               => '/usr/share/foreman',
          :listen_on_interface    => '192.168.0.1',
          :ruby                   => '/usr/bin/tfm-ruby',
          :priority               => '15',
          :use_vhost              => true,
          :servername             => facts[:fqdn],
          :serveraliases          => ['foreman', 'also.foreman'],
          :ssl                    => true,
          :ssl_cert               => '/cert.pem',
          :ssl_key                => '/key.pem',
          :ssl_ca                 => '/ca.pem',
          :ssl_chain              => '/ca.pem',
          :ssl_certs_dir          => '',
          :ssl_crl                => '',
          :ssl_protocol           => '-all +TLSv1.2',
          :user                   => 'foreman',
          :prestart               => true,
          :min_instances          => 1,
          :start_timeout          => 90,
          :foreman_url            => "https://#{facts[:fqdn]}",
          :keepalive              => true,
          :max_keepalive_requests => 100,
          :keepalive_timeout      => 5,
          :server_port            => 80,
          :server_ssl_port        => 443,
          :ipa_authentication     => false,
        } end

        it do
          should contain_apache__vhost('foreman-ssl').without_ssl_crl
          should contain_apache__vhost('foreman-ssl').without_ssl_crl_chain
        end
      end

      describe 'with keepalive parameters set' do
        let :params do {
            :app_root               => '/usr/share/foreman',
            :listen_on_interface    => '192.168.0.1',
            :priority               => '05',
            :use_vhost              => true,
            :servername             => facts[:fqdn],
            :serveraliases          => ['foreman', 'also.foreman'],
            :ssl                    => true,
            :ssl_cert               => '/cert.pem',
            :ssl_certs_dir          => '',
            :ssl_key                => '/key.pem',
            :ssl_ca                 => '/ca.pem',
            :ssl_chain              => '/ca.pem',
            :ssl_crl                => '/crl.pem',
            :ssl_protocol           => '-all +TLSv1.2',
            :user                   => 'foreman',
            :prestart               => true,
            :min_instances          => 1,
            :start_timeout          => 90,
            :ruby                   => '/usr/bin/tfm-ruby',
            :foreman_url            => "https://#{facts[:fqdn]}",
            :keepalive              => false,
            :max_keepalive_requests => 10,
            :keepalive_timeout      => 15,
            :server_port            => 80,
            :server_ssl_port        => 443,
            :ipa_authentication     => false,
        } end

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
        let :params do {
          :app_root               => '/usr/share/foreman',
          :listen_on_interface    => '192.168.0.1',
          :use_vhost              => true,
          :priority               => '20',
          :servername             => facts[:fqdn],
          :serveraliases          => ['foreman', 'also.foreman'],
          :ssl                    => true,
          :ssl_cert               => '/cert.pem',
          :ssl_certs_dir          => '',
          :ssl_key                => '/key.pem',
          :ssl_ca                 => '/ca.pem',
          :ssl_crl                => '/crl.pem',
          :ssl_chain              => '/ca.pem',
          :ssl_protocol           => '-all +TLSv1.2',
          :prestart               => true,
          :user                   => 'foreman',
          :min_instances          => 1,
          :start_timeout          => 90,
          :ruby                   => '/usr/bin/tfm-ruby',
          :foreman_url            => "https://#{facts[:fqdn]}",
          :keepalive              => true,
          :max_keepalive_requests => 100,
          :keepalive_timeout      => 5,
          :server_port            => 80,
          :server_ssl_port        => 443,
          :ipa_authentication     => false,
        } end

        case facts[:osfamily]
          when 'RedHat'
            http_dir = '/etc/httpd'
          when 'Debian'
            http_dir = '/etc/apache2'
        end

        it 'should contain virt host plugin dir' do
          should_not contain_file("#{http_dir}/conf.d/05-foreman.d")
          should contain_file("#{http_dir}/conf.d/20-foreman.d").with_ensure('directory')
        end

        it 'should contain ssl virt host plugin dir' do
          should_not contain_file("#{http_dir}/conf.d/05-foreman-ssl.d")
          should contain_file("#{http_dir}/conf.d/20-foreman-ssl.d").with_ensure('directory')
        end

        it 'should include a http vhost' do
          should contain_apache__vhost('foreman').
            with_priority(20).
            with_additional_includes(["#{http_dir}/conf.d/20-foreman.d/*.conf"])
        end

        it 'should include a http ssl vhost' do
          should contain_apache__vhost('foreman-ssl').
            with_priority(20).
            with_ssl(true).
            with_additional_includes(["#{http_dir}/conf.d/20-foreman-ssl.d/*.conf"])
        end
      end

      describe 'with different ports set' do
        let :params do {
          :app_root               => '/usr/share/foreman',
          :listen_on_interface    => '192.168.0.1',
          :use_vhost              => true,
          :priority               => '20',
          :servername             => facts[:fqdn],
          :serveraliases          => ['foreman', 'also.foreman'],
          :ssl                    => true,
          :ssl_cert               => '/cert.pem',
          :ssl_certs_dir          => '',
          :ssl_key                => '/key.pem',
          :ssl_ca                 => '/ca.pem',
          :ssl_crl                => '/crl.pem',
          :ssl_chain              => '/ca.pem',
          :ssl_protocol           => '-all +TLSv1.2',
          :prestart               => true,
          :user                   => 'foreman',
          :min_instances          => 1,
          :start_timeout          => 90,
          :ruby                   => '/usr/bin/tfm-ruby',
          :foreman_url            => "https://#{facts[:fqdn]}",
          :keepalive              => true,
          :max_keepalive_requests => 100,
          :keepalive_timeout      => 5,
          :server_port            => 8080,
          :server_ssl_port        => 8443,
          :ipa_authentication     => false,
        } end

        it 'should set the respective parameters' do
          should contain_apache__vhost('foreman').with_port(8080)
          should contain_apache__vhost('foreman').with_passenger_pre_start("http://#{facts[:fqdn]}:8080")
          should contain_apache__vhost('foreman-ssl').with_port(8443)
          should contain_apache__vhost('foreman-ssl').with_passenger_pre_start("https://#{facts[:fqdn]}:8443")
        end
      end

      describe 'with ipa_authentication' do
        let :params do {
          :app_root               => '/usr/share/foreman',
          :use_vhost              => true,
          :listen_on_interface    => '192.168.0.1',
          :ruby                   => '/usr/bin/tfm-ruby',
          :priority               => '15',
          :servername             => facts[:fqdn],
          :serveraliases          => ['foreman'],
          :ssl                    => false,
          :ssl_cert               => '/cert.pem',
          :ssl_certs_dir          => '',
          :ssl_key                => '/key.pem',
          :ssl_ca                 => '/ca.pem',
          :ssl_chain              => '/ca.pem',
          :ssl_crl                => '/crl.pem',
          :ssl_protocol           => '-all +TLSv1.2',
          :user                   => 'foreman',
          :prestart               => true,
          :min_instances          => 1,
          :start_timeout          => 90,
          :foreman_url            => "https://#{facts[:fqdn]}",
          :keepalive              => true,
          :max_keepalive_requests => 100,
          :keepalive_timeout      => 5,
          :server_port            => 80,
          :server_ssl_port        => 443,
          :ipa_authentication     => true,
        } end

        it { should contain_class('apache::mod::authnz_pam') }
        it { should contain_class('apache::mod::intercept_form_submit') }
        it { should contain_class('apache::mod::lookup_identity') }
        it { should contain_class('apache::mod::auth_kerb') }
      end
    end
  end
end
