require 'spec_helper'


describe 'foreman::config::passenger' do
  context 'on redhat' do
    let :facts do {
      :concat_basedir          => '/nonexistant',
      :fqdn                    => 'foreman.example.org',
      :operatingsystem         => 'RedHat',
      :operatingsystemrelease  => '6.4',
      :osfamily                => 'RedHat',
    } end

    describe 'with minimal parameters' do
      let :params do {
        :app_root => '/usr/share/foreman',
        :ssl      => false,
        :user     => 'foreman',
        :prestart      => true,
        :min_instances => '1',
        :start_timeout => '600',
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
        :ssl           => true,
        :ssl_cert      => 'cert.pem',
        :ssl_key       => 'key.pem',
        :ssl_ca        => 'ca.pem',
        :ssl_crl       => 'crl.pem',
        :prestart      => true,
        :min_instances => '1',
        :start_timeout => '600',
        :ruby          => '/usr/bin/ruby193-ruby'
      } end

      it 'should contain the docroot' do
        should contain_file("#{params[:app_root]}/public")
      end

      it 'should contain virt host plugin dir' do
         should contain_file('/etc/httpd/conf.d/05-foreman.d').with({
           'ensure'  => 'directory',
         })
      end

      it 'should contain ssl virt host plugin dir' do
         should contain_file('/etc/httpd/conf.d/05-foreman-ssl.d').with({
           'ensure'  => 'directory',
         })
      end

      it 'should include a http vhost' do
        should contain_apache__vhost('foreman').with({
          :ip                      => nil,
          :servername              => facts[:fqdn],
          :serveraliases           => ['foreman'],
          :add_default_charset     => 'UTF-8',
          :docroot                 => "#{params[:app_root]}/public",
          :priority                => '05',
          :options                 => ['SymLinksIfOwnerMatch'],
          :port                    => 80,
          :passenger_min_instances => '1',
          :passenger_pre_start     => "http://#{facts[:fqdn]}",
          :passenger_start_timeout => '600',
          :passenger_ruby          => "/usr/bin/ruby193-ruby",
          :custom_fragment         => %r{^<Directory #{params[:app_root]}/public>$},
        })
      end

      it 'should include a https vhost' do
        should contain_apache__vhost('foreman-ssl').with({
          :ip                      => nil,
          :servername              => facts[:fqdn],
          :serveraliases           => ['foreman'],
          :add_default_charset     => 'UTF-8',
          :docroot                 => "#{params[:app_root]}/public",
          :priority                => '05',
          :options                 => ['SymLinksIfOwnerMatch'],
          :port                    => 443,
          :passenger_min_instances => '1',
          :passenger_pre_start     => "https://#{facts[:fqdn]}",
          :passenger_start_timeout => '600',
          :passenger_ruby          => "/usr/bin/ruby193-ruby",
          :ssl                     => true,
          :ssl_cert                => params[:ssl_cert],
          :ssl_key                 => params[:ssl_key],
          :ssl_chain               => params[:ssl_chain],
          :ssl_ca                  => params[:ssl_ca],
          :ssl_crl                 => params[:ssl_crl],
          :ssl_verify_client       => 'optional',
          :ssl_options             => '+StdEnvVars',
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
        :ssl           => true,
        :ssl_cert      => 'cert.pem',
        :ssl_key       => 'key.pem',
        :ssl_ca        => 'ca.pem',
        :prestart      => true,
        :min_instances => '1',
        :start_timeout => '600',
        :ruby          => '/usr/bin/ruby193-ruby'
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
        :ssl           => true,
        :ssl_cert      => 'cert.pem',
        :ssl_key       => 'key.pem',
        :ssl_ca        => 'ca.pem',
        :ssl_crl       => '',
        :prestart      => true,
        :min_instances => '1',
        :start_timeout => '600',
        :ruby          => '/usr/bin/ruby193-ruby'
      } end

      it do
        should contain_apache__vhost('foreman-ssl').without_ssl_crl
        should contain_apache__vhost('foreman-ssl').without_ssl_crl_chain
      end
    end
  end

  context 'on debian' do
    let :facts do {
      :concat_basedir         => '/nonexistant',
      :fqdn                   => 'foreman.example.org',
      :osfamily               => 'Debian',
      :operatingsystem        => 'Debian',
      :operatingsystemrelease => 'squeeze',
      :lsbdistcodename        => 'squeeze',
    } end

    describe 'with vhost and ssl' do
      let :params do {
        :app_root  => '/usr/share/foreman',
        :use_vhost => true,
        :ssl       => true,
        :ssl_cert  => 'cert.pem',
        :ssl_key   => 'key.pem',
        :ssl_ca    => 'ca.pem',
        :prestart      => false,
        :min_instances => Undef.new,
        :start_timeout => Undef.new,
      } end

      it 'should not include a pre-start https on Squeeze' do
        should contain_apache__vhost('foreman-ssl').without_passenger_pre_start
      end

      it 'should not include min instances on Squeeze' do
        should contain_apache__vhost('foreman-ssl').without_passenger_min_instances
      end

      it 'should not include start timeout on Squeeze' do
        should contain_apache__vhost('foreman-ssl').without_passenger_start_timeout
      end

      it 'should not include the Ruby interpreter' do
        should contain_apache__vhost('foreman').without_passenger_ruby
      end
    end
  end
end
