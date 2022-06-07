require 'spec_helper'

describe 'foreman::plugin::ovirt_provision' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let :facts do
        facts
      end

      let(:pre_condition) { 'include foreman' }
      let(:package_name) do
        case facts[:osfamily]
        when 'RedHat'
          'rubygem-ovirt_provision_plugin'
        when 'Debian'
          'ruby-ovirt_provision_plugin'
        end
      end

      it { should compile.with_all_deps }
      it { should contain_foreman__plugin('ovirt_provision').with_package(package_name) }
    end
  end
end
