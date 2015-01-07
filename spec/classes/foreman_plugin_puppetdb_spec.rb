require 'spec_helper'

describe 'foreman::plugin::puppetdb' do
  on_supported_os.each do |os, facts|
    next if only_test_os() and not only_test_os.include?(os)
    next if exclude_test_os() and exclude_test_os.include?(os)

    context "on #{os}" do
      let :facts do
        facts
      end

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
    end
  end
end
