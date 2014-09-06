require 'spec_helper'

describe 'foreman::cli' do
  context 'standalone with parameters' do
    let(:params) do {
      'foreman_url' => 'http://example.com',
      'username'    => 'joe',
      'password'    => 'secret',
    } end

    it { should contain_package('foreman-cli').with_ensure('installed') }

    describe '/etc/hammer/cli.modules.d/foreman.yml' do
      it 'should contain settings' do
        content = subject.resource('file', '/etc/hammer/cli.modules.d/foreman.yml').send(:parameters)[:content]
        content.split("\n").reject { |c| c =~ /(^\s*#|^$)/ }.should == [
          ":foreman:",
          "  :enable_module: true",
          "  :host: 'http://example.com'",
        ]
      end
    end

    describe '/root/.hammer/cli.modules.d/foreman.yml' do
      it { should contain_file('/root/.hammer/cli.modules.d/foreman.yml').with_replace(false) }

      it 'should contain settings' do
        content = subject.resource('file', '/root/.hammer/cli.modules.d/foreman.yml').send(:parameters)[:content]
        content.split("\n").reject { |c| c =~ /(^\s*#|^$)/ }.should == [
          ":foreman:",
          "  :username: 'joe'",
          "  :password: 'secret'",
          "  :refresh_cache: false",
          "  :request_timeout: 120",
        ]
      end
    end

    describe 'with manage_root_config=false' do
      let(:params) do {
        'foreman_url' => 'http://example.com',
        'username'    => 'joe',
        'password'    => 'secret',
        'manage_root_config' => false,
      } end

      it { should_not contain_file('/root/.hammer') }
      it { should_not contain_file('/root/.hammer/cli.modules.d/foreman.yml') }
    end
  end

  context 'with foreman' do
    let :facts do {
      :concat_basedir => '/tmp',
      :operatingsystemrelease => '6.4',
      :operatingsystem=> 'RedHat',
      :osfamily => 'RedHat',
      :fqdn     => 'foreman.example.com',
    } end

    let :pre_condition do
      "class { 'foreman':
         admin_username => 'joe',
         admin_password => 'secret',
       }"
    end

    it { should contain_package('foreman-cli').with_ensure('installed') }

    describe '/etc/hammer/cli.modules.d/foreman.yml' do
      it 'should contain settings from foreman' do
        content = subject.resource('file', '/etc/hammer/cli.modules.d/foreman.yml').send(:parameters)[:content]
        content.split("\n").reject { |c| c =~ /(^\s*#|^$)/ }.should == [
          ":foreman:",
          "  :enable_module: true",
          "  :host: 'https://#{facts[:fqdn]}'",
        ]
      end
    end

    describe '/root/.hammer/cli.modules.d/foreman.yml' do
      it 'should contain settings from foreman' do
        content = subject.resource('file', '/root/.hammer/cli.modules.d/foreman.yml').send(:parameters)[:content]
        content.split("\n").reject { |c| c =~ /(^\s*#|^$)/ }.should == [
          ":foreman:",
          "  :username: 'joe'",
          "  :password: 'secret'",
          "  :refresh_cache: false",
          "  :request_timeout: 120",
        ]
      end
    end
  end
end
