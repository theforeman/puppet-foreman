require 'spec_helper'

describe 'foreman::plugin::tasks' do
  describe 'Fedora' do
    let :facts do
      {
          :osfamily => 'RedHat',
          :operatingsystem => 'Fedora',
      }
    end

    it 'should call the plugin' do
      should contain_foreman__plugin('tasks').with_package('rubygem-foreman-tasks')
      should contain_service('foreman-tasks').with('ensure' => 'running', 'enable' => 'true', 'name' => 'foreman-tasks')
    end
  end

  describe 'RHEL' do
    let :facts do
      {
          :osfamily => 'RedHat',
          :operatingsystem => 'RedHat',
      }
    end

    it 'should call the plugin' do
      should contain_foreman__plugin('tasks').with_package('tfm-rubygem-foreman-tasks')
      should contain_service('foreman-tasks').with('ensure' => 'running', 'enable' => 'true', 'name' => 'foreman-tasks')
    end
  end

  describe 'Debian' do
    let :facts do
      {
          :osfamily => 'Debian',
      }
    end

    it 'should call the plugin' do
      should contain_foreman__plugin('tasks').with_package('ruby-foreman-tasks')
      should contain_service('foreman-tasks').with('ensure' => 'running', 'enable' => 'true', 'name' => 'ruby-foreman-tasks')
    end
  end
end
