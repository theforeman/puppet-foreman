require 'spec_helper'

describe 'foreman::plugin::puppetdb' do
  on_os_under_test.each do |os, facts|
    context "on #{os}" do
      let :facts do
        facts
      end

      let(:pre_condition) { 'include foreman' }

      it { should compile.with_all_deps }

      if facts[:operatingsystem] == 'Fedora'
        it 'should call the plugin' do
          should contain_foreman__plugin('puppetdb').with_package('rubygem-puppetdb_foreman')
        end
      elsif facts[:osfamily] == 'RedHat'
        it 'should call the plugin' do
          should contain_foreman__plugin('puppetdb').with_package('tfm-rubygem-puppetdb_foreman')
        end
      elsif facts[:osfamily] == 'Debian'
        it 'should call the plugin' do
          should contain_foreman__plugin('puppetdb').with_package('ruby-puppetdb-foreman')
        end
      end

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
