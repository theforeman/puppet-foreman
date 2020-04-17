require 'spec_helper'

describe 'foreman::plugin::puppetdb' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let :facts do
        facts
      end

      let(:pre_condition) { 'include foreman' }
      let(:package_name) do
        case facts[:osfamily]
        when 'RedHat'
          facts[:os]['release']['major'] == '7' ? 'tfm-rubygem-puppetdb_foreman' : 'rubygem-puppetdb_foreman'
        when 'Debian'
          'ruby-puppetdb_foreman'
        end
      end

      it { should compile.with_all_deps }
      it { should contain_foreman__plugin('puppetdb').with_package(package_name) }
    end
  end
end
