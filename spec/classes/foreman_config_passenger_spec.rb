require 'spec_helper'


describe 'foreman::config::passenger' do
  let :default_facts do
    {
      :concat_basedir => '/tmp',
      :interfaces     => 'lo',
      :ipaddress_lo   => '127.0.0.1',
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

      it do
        should contain_class('apache::ssl')
        should contain_class('passenger')
        should_not contain_class('::passenger::install::scl')

        should contain_file('foreman_vhost').with({
          :path    => '/etc/httpd/conf.d/foreman.conf',
          :mode    => '0644',
          :notify  => 'Class[Foreman::Service]',
          :require => 'Class[Foreman::Install]',
        })

        should contain_file('foreman_vhost').with_content(/<VirtualHost \*:80>/)

        should contain_file('foreman_vhost').with_content(/<VirtualHost \*:443>/)

        should contain_file('foreman_vhost').with_content(/access plus 1 year/)

        should contain_file('/usr/share/foreman/config.ru').with({
          :owner   => 'foreman',
          :require => 'Class[Foreman::Install]',
        })

        should contain_file('/usr/share/foreman/config/environment.rb').with({
          :owner   => 'foreman',
          :require => 'Class[Foreman::Install]',
        })
      end
    end

    describe 'with listen_interface' do
      let :pre_condition do
        "class {'foreman':
          passenger_interface => 'lo',
        }"
      end

      it 'should contain the HTTP vhost' do
        should contain_file('foreman_vhost').with({
          :content => /<VirtualHost 127.0.0.1:80>/,
        })
      end

      it 'should contain the HTTPS vhost' do
        should contain_file('foreman_vhost').with({
          :content => /<VirtualHost 127.0.0.1:443>/,
        })
      end
    end

    describe 'with scl_prefix' do
      let :pre_condition do
        "class {'foreman':
          passenger_scl => 'ruby193',
        }"
      end

      it 'should include scl' do
        should contain_class('passenger::install::scl')
      end
    end

    describe 'without ssl' do
      let :pre_condition do
        "class {'foreman':
          ssl => false,
        }"
      end

      it 'should contain the HTTP vhost' do
        should contain_file('foreman_vhost').with_content(/<VirtualHost \*:80>/)
      end

      it 'should not contain the HTTPS vhost' do
        should_not contain_file('foreman_vhost').with_content(/<VirtualHost \*:443>/)
      end
    end

    describe 'with custom ssl cert' do
      let :pre_condition do
        "class {'foreman':
          server_ssl_cert => 'foo',
          server_ssl_key  => 'bar',
          server_ssl_ca   => 'baz',
          ssl             => true,
        }"
      end

      it 'should specify trust chain' do
        should contain_file('foreman_vhost').with_content(/SSLCertificateFile\s+foo/)
        should contain_file('foreman_vhost').with_content(/SSLCertificateKeyFile\s+bar/)
        should contain_file('foreman_vhost').with_content(/SSLCertificateChainFile\s+baz/)
      end
    end
  end
end
