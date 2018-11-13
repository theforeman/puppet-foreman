require 'spec_helper'

describe 'foreman::config::passenger::fragment' do
  let(:title) { 'myfragment' }
  let(:pre_condition) { 'include foreman' }

  on_os_under_test.each do |os, facts|
    context "on #{os}" do
      let(:facts) { facts }
      let(:params) do
        {
          content: 'http',
          ssl_content: 'https',
        }
      end

      it { is_expected.to compile.with_all_deps }
      it do
        is_expected.to contain_foreman__config__apache__fragment('myfragment')
          .with_content('http')
          .with_ssl_content('https')
      end
    end
  end
end
