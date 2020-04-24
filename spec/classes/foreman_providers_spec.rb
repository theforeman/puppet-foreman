require 'spec_helper'

describe 'foreman::providers' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) { facts }
      let(:oauth_os) { 'puppet-agent-oauth' }

      context 'with defaults' do
        it { should compile.with_all_deps }
        it { should contain_package(oauth_os) }
      end

      context 'with oauth => false' do
        let(:params) do
          {
            'oauth' => false
          }
        end

        it { should_not contain_package(oauth_os) }
      end

      context 'with foreman::repo' do
        let(:pre_condition) { 'include foreman::repo' }

        it { is_expected.to compile.with_all_deps }
        it { should contain_package(oauth_os).that_requires('Anchor[foreman::repo]') }
      end

      context 'with foreman' do
        let(:pre_condition) { 'include foreman' }

        it { is_expected.to compile.with_all_deps }
        it { should contain_package(oauth_os).that_comes_before('Class[foreman]') }
      end
    end
  end
end
