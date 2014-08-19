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
        :app_root  => '/usr/share/foreman',
        :use_vhost => true,
        :servername => facts[:fqdn],
        :ssl       => true,
        :ssl_cert  => 'cert.pem',
        :ssl_key   => 'key.pem',
        :ssl_ca    => 'ca.pem',
        :prestart      => true,
        :min_instances => '1',
        :start_timeout => '600',
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
          :ip              => nil,
          :servername      => facts[:fqdn],
          :serveraliases   => ['foreman'],
          :docroot         => "#{params[:app_root]}/public",
          :priority        => '05',
          :options         => ['SymLinksIfOwnerMatch'],
          :port            => 80,
          :custom_fragment => %r{^<Directory #{params[:app_root]}/public>$},
        })
      end

      it 'should include a pre-start http fragment' do
        should contain_apache__vhost('foreman').with({
          :custom_fragment => %r{^PassengerPreStart http://#{facts[:fqdn]}$},
        })
      end

      it 'should include a https vhost' do
        should contain_apache__vhost('foreman-ssl').with({
          :ip                => nil,
          :servername        => facts[:fqdn],
          :serveraliases     => ['foreman'],
          :docroot           => "#{params[:app_root]}/public",
          :priority          => '05',
          :options           => ['SymLinksIfOwnerMatch'],
          :port              => 443,
          :ssl               => true,
          :ssl_cert          => params[:ssl_cert],
          :ssl_key           => params[:ssl_key],
          :ssl_chain         => params[:ssl_chain],
          :ssl_ca            => params[:ssl_ca],
          :ssl_verify_client => 'optional',
          :ssl_options       => '+StdEnvVars',
          :ssl_verify_depth  => '3',
          :custom_fragment   => %r{^<Directory #{params[:app_root]}/public>$},
        })
      end

      it 'should include a pre-start https fragment' do
        should contain_apache__vhost('foreman-ssl').with({
          :custom_fragment => %r{^PassengerPreStart https://#{facts[:fqdn]}$},
        })
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
        :min_instances => '0',
        :start_timeout => '0',
      } end

      it 'should not include a pre-start https fragment on Squeeze' do
        should contain_apache__vhost('foreman-ssl').without({
          :custom_fragment => %r{^PassengerPreStart},
        })
      end

      it 'should not include min instances fragment on Squeeze' do
        should contain_apache__vhost('foreman-ssl').without({
          :custom_fragment => %r{^PassengerMinInstances},
        })
      end

      it 'should not include start timeout fragment on Squeeze' do
        should contain_apache__vhost('foreman-ssl').without({
          :custom_fragment => %r{^PassengerStartTimeout},
        })
      end
    end
  end
end
