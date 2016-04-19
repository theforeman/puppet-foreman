require 'spec_helper'

describe 'foreman::providers' do

  on_supported_os.each do |os, facts|
    next if only_test_os() and not only_test_os.include?(os)
    next if exclude_test_os() and exclude_test_os.include?(os)

    context "on #{os}" do
      let(:facts) { facts }

      case facts[:osfamily]
      when 'RedHat'
        oauth_os = 'rubygem-oauth'
        json = 'rubygem-json'
        apipie_bindings = 'rubygem-apipie-bindings'
        foreman_api = 'rubygem-foreman_api'
      when 'Debian'
        oauth_os = 'ruby-oauth'
        json = 'ruby-json'
        apipie_bindings = 'ruby-apipie-bindings'
        foreman_api = 'ruby-foreman-api'
      end

      context 'with defaults' do
        if facts[:rubyversion].start_with?('1.8')
          it { should contain_package(json).with_ensure('present') }
        else
          it { should_not contain_package(json) }
        end
        it { should_not contain_package(apipie_bindings) }
        it { should_not contain_package(foreman_api) }
      end

      context 'with defaults on Puppet 3' do
        let(:facts) { facts.merge(:puppetversion => '3.8.6') }
        it { should contain_package(oauth_os).with_ensure('present') }
      end

      context 'with defaults on Puppet 4' do
        let(:facts) { facts.merge(:puppetversion => '4.0.0') }
        it { should contain_package('puppet-agent-oauth').with_ensure('present') }
      end

      context 'with foreman_api only' do
        let(:params) do {
          'apipie_bindings' => false,
          'foreman_api' => true,
        } end

        it { should_not contain_package(apipie_bindings) }
        it { should contain_package(foreman_api).with_ensure('present') }
      end

      context 'with apipie_bindings => true' do
        let(:params) do {
          'apipie_bindings' => true,
        } end

        it { should contain_package(apipie_bindings).with_ensure('present') }
      end

      context 'with json => true' do
        let(:params) do {
          'json' => true,
        } end

        it { should contain_package(json).with_ensure('present') }
      end

      context 'with oauth => true' do
        let(:facts) { facts.merge(:puppetversion => '3.8.6') }
        let(:params) do {
          'oauth' => true,
        } end

        it { should contain_package(oauth_os).with_ensure('present') }
      end
    end
  end
end
