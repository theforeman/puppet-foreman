require 'spec_helper'

describe 'foreman::plugin::tasks' do
  on_supported_os.each do |os, facts|
    next if only_test_os() and not only_test_os.include?(os)
    next if exclude_test_os() and exclude_test_os.include?(os)

    context "on #{os}" do
      let :facts do
        facts
      end

      case facts[:osfamily]
      when 'RedHat'
        package_name = case facts[:operatingsystem]
                       when 'Fedora'
                         'rubygem-foreman-tasks'
                       else
                         'tfm-rubygem-foreman-tasks'
                       end
        service_name = 'foreman-tasks'
      when 'Debian'
        package_name = 'ruby-foreman-tasks'
        service_name = 'ruby-foreman-tasks'
      else
        package_name = 'foreman-tasks'
        service_name = 'foreman-tasks'
      end

      it 'should call the plugin' do
        should contain_foreman__plugin('tasks').with_package(package_name)
        should contain_service('foreman-tasks').with('ensure' => 'running', 'enable' => 'true', 'name' => service_name)
      end
    end
  end
end
