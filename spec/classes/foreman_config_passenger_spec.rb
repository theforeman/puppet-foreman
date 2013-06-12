require 'spec_helper'


describe 'foreman::config::passenger' do
  let :default_facts do
    {
      :concat_basedir           => '/tmp',
      :interfaces               => 'lo',
      :ipaddress_lo             => '127.0.0.1',
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

      it do
        should include_class('apache::ssl')
        should include_class('passenger')
        should_not include_class('::passenger::install::scl')

        should contain_file('foreman_vhost').with({
          :path    => '/etc/httpd/conf.d/foreman.conf',
          :content => /<VirtualHost \*:80>/,
          :mode    => '0644',
          :notify  => 'Exec[reload-apache]',
          :require => 'Class[Foreman::Install]',
        })

        should contain_exec('restart_foreman').with({
          :command     => '/bin/touch /usr/share/foreman/tmp/restart.txt',
          :refreshonly => true,
          :cwd         => '/usr/share/foreman',
          :path        => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
        })

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

      it do
        should contain_file('foreman_vhost').with({
          :content => /<VirtualHost 127.0.0.1:80>/,
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
        should include_class('passenger::install::scl')
      end
    end
  end
end
