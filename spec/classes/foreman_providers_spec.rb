require 'spec_helper'

describe 'foreman::providers' do
  on_os_under_test.each do |os, facts|
    context "on #{os}" do
      let(:facts) { facts }

      case facts[:osfamily]
      when 'RedHat'
        oauth_os = 'rubygem-oauth'
      when 'Debian'
        oauth_os = 'ruby-oauth'
      end

      context 'with defaults' do
        it { should compile.with_all_deps }
      end

      context 'with defaults on Puppet non-AIO' do
        let(:facts) { super().merge(rubysitedir: '/usr/lib/ruby/site_ruby/2.1.0') }
        it { should contain_package(oauth_os).with_ensure('present') }
      end

      context 'with defaults on Puppet AIO' do
        let(:facts) { super().merge(rubysitedir: '/opt/puppetlabs/puppet/lib/ruby/site_ruby/2.1.0') }
        it { should contain_package('puppet-agent-oauth').with_ensure('present') }
      end

      context 'with oauth => false' do
        let(:params) do
          {
            'oauth' => false
          }
        end

        it { should_not contain_package(oauth_os) }
      end

      context 'with foreman' do
        let(:pre_condition) { 'include foreman' }

        it { is_expected.to compile.with_all_deps }
        it { should contain_package(oauth_os).that_subscribes_to('Class[foreman::repo]') }
      end
    end
  end
end
