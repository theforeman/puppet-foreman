require 'spec_helper'


describe 'foreman::config::passenger' do
  on_supported_os.each do |os, facts|
    next if only_test_os() and not only_test_os.include?(os)
    next if exclude_test_os() and exclude_test_os.include?(os)

    context "on #{os}" do
      let :facts do
        facts.merge({
          :concat_basedir => '/tmp',
        })
      end

      describe 'with minimal parameters' do
        let :params do {
          :app_root      => '/usr/share/foreman',
          :ssl           => false,
          :user          => 'foreman',
          :prestart      => true,
          :min_instances => '1',
          :start_timeout => '600',
          :foreman_url   => "https://#{facts[:fqdn]}",
        } end

        it 'should include apache with modules' do
          should contain_class('apache').that_comes_before('Anchor[foreman::config::passenger_end]')
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
          :app_root      => '/usr/share/foreman',
          :use_vhost     => true,
          :servername    => facts[:fqdn],
          :serveraliases => ['foreman', 'also.foreman'],
          :ssl           => true,
          :ssl_cert      => 'cert.pem',
          :ssl_certs_dir => '',
          :ssl_key       => 'key.pem',
          :ssl_ca        => 'ca.pem',
          :ssl_crl       => 'crl.pem',
          :prestart      => true,
          :min_instances => 1,
          :start_timeout => 600,
          :ruby          => '/usr/bin/tfm-ruby',
          :foreman_url   => "https://#{facts[:fqdn]}",
        } end

        case facts[:osfamily]
        when 'RedHat'
          http_dir = '/etc/httpd'
        when 'Debian'
          http_dir = '/etc/apache2'
        end

        it 'should contain the docroot' do
          should contain_file("#{params[:app_root]}/public")
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
            :passenger_pre_start     => "http://#{facts[:fqdn]}",
            :passenger_start_timeout => 600,
            :passenger_ruby          => '/usr/bin/tfm-ruby',
            :custom_fragment         => %r{^<Directory #{params[:app_root]}/public>$},
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
            :passenger_pre_start     => "https://#{facts[:fqdn]}",
            :passenger_start_timeout => 600,
            :passenger_ruby          => '/usr/bin/tfm-ruby',
            :ssl                     => true,
            :ssl_cert                => params[:ssl_cert],
            :ssl_certs_dir           => params[:ssl_certs_dir],
            :ssl_key                 => params[:ssl_key],
            :ssl_chain               => params[:ssl_chain],
            :ssl_ca                  => params[:ssl_ca],
            :ssl_crl                 => params[:ssl_crl],
            :ssl_verify_client       => 'optional',
            :ssl_options             => '+StdEnvVars +ExportCertData',
            :ssl_verify_depth        => '3',
            :ssl_crl_check           => 'chain',
            :custom_fragment         => %r{^<Directory #{params[:app_root]}/public>$},
          })
        end
      end

      describe 'with vhost and ssl, no CRL' do
        let :params do {
          :app_root      => '/usr/share/foreman',
          :use_vhost     => true,
          :servername    => facts[:fqdn],
          :serveraliases => ['foreman', 'also.foreman'],
          :ssl           => true,
          :ssl_cert      => 'cert.pem',
          :ssl_key       => 'key.pem',
          :ssl_ca        => 'ca.pem',
          :prestart      => true,
          :min_instances => 1,
          :start_timeout => 600,
          :ruby          => '/usr/bin/tfm-ruby',
          :foreman_url   => "https://#{facts[:fqdn]}",
        } end

        it do
          should contain_apache__vhost('foreman-ssl').without_ssl_crl
          should contain_apache__vhost('foreman-ssl').without_ssl_crl_chain
        end
      end

      describe 'with vhost and ssl, no CRL explicitly' do
        let :params do {
          :app_root      => '/usr/share/foreman',
          :use_vhost     => true,
          :servername    => facts[:fqdn],
          :serveraliases => ['foreman', 'also.foreman'],
          :ssl           => true,
          :ssl_cert      => 'cert.pem',
          :ssl_key       => 'key.pem',
          :ssl_ca        => 'ca.pem',
          :ssl_crl       => '',
          :prestart      => true,
          :min_instances => 1,
          :start_timeout => 600,
          :ruby          => '/usr/bin/tfm-ruby',
          :foreman_url   => "https://#{facts[:fqdn]}",
        } end

        it do
          should contain_apache__vhost('foreman-ssl').without_ssl_crl
          should contain_apache__vhost('foreman-ssl').without_ssl_crl_chain
        end
      end

      describe 'without prestart, min_instances and start_timeout' do
        let :params do {
          :app_root      => '/usr/share/foreman',
          :use_vhost     => true,
          :ssl           => true,
          :ssl_cert      => 'cert.pem',
          :ssl_key       => 'key.pem',
          :ssl_ca        => 'ca.pem',
          :prestart      => false,
          :min_instances => Undef.new,
          :start_timeout => Undef.new,
          :foreman_url   => "https://#{facts[:fqdn]}",
        } end

        it 'should not include a pre-start' do
          should contain_apache__vhost('foreman').without_passenger_pre_start
          should contain_apache__vhost('foreman-ssl').without_passenger_pre_start
        end

        it 'should not include min instances' do
          should contain_apache__vhost('foreman').without_passenger_min_instances
          should contain_apache__vhost('foreman-ssl').without_passenger_min_instances
        end

        it 'should not include start timeout' do
          should contain_apache__vhost('foreman').without_passenger_start_timeout
          should contain_apache__vhost('foreman-ssl').without_passenger_start_timeout
        end

        it 'should not include the Ruby interpreter' do
          should contain_apache__vhost('foreman').without_passenger_ruby
          should contain_apache__vhost('foreman-ssl').without_passenger_ruby
        end
      end
    end
  end
end
