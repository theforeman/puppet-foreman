require 'spec_helper'

describe 'foreman::providers' do

  on_supported_os.each do |os, facts|
    next if only_test_os() and not only_test_os.include?(os)
    next if exclude_test_os() and exclude_test_os.include?(os)

    context "on #{os}" do
      let(:facts) { facts }

      case facts[:osfamily]
      when 'RedHat'
        apipie_bindings = 'rubygem-apipie-bindings'
        foreman_api = 'rubygem-foreman_api'
      when 'Debian'
        apipie_bindings = 'ruby-apipie-bindings'
        foreman_api = 'ruby-foreman-api'
      end

      context 'with defaults' do
        it { should contain_package(apipie_bindings).with_ensure('installed') }
        it { should_not contain_package(foreman_api) }
      end

      context 'with foreman_api only' do
        let(:params) do {
          'apipie_bindings' => false,
          'foreman_api' => true,
        } end

        it { should_not contain_package(apipie_bindings) }
        it { should contain_package(foreman_api).with_ensure('installed') }
      end
    end
  end
end
