require 'spec_helper'

describe 'foreman::plugin::puppetdb' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let :facts do
        facts
      end

      let(:pre_condition) { 'include foreman' }
      let(:package_name) do
        case facts[:os]['family']
        when 'RedHat'
          'rubygem-puppetdb_foreman'
        when 'Debian'
          'ruby-puppetdb_foreman'
        end
      end

      it { should compile.with_all_deps }
      it { should contain_foreman__plugin('puppetdb').with_package(package_name) }
      it do
        should contain_foreman_config_entry('puppetdb_enabled')
          .with_value(true)
          .that_requires(['Class[foreman::database]', 'Foreman::Plugin[puppetdb]'])
      end
      it do
        should contain_foreman_config_entry('puppetdb_address')
          .with_value('https://localhost:8081/pdb/cmd/v1')
          .that_requires(['Class[foreman::database]', 'Foreman::Plugin[puppetdb]'])
      end
    end
  end
end
