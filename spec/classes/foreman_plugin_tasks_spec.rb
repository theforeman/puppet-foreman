require 'spec_helper'

describe 'foreman::plugin::tasks' do
  describe "Fedora" do
    let :facts do
      {
          :osfamily => 'RedHat',
          :operatingsystem => 'Fedora',
      }
    end

    it 'should call the plugin' do
      should contain_foreman__plugin('tasks').with_package('rubygem-foreman-tasks')
      should contain_service('foreman-tasks').with('ensure' => 'running', 'enable' => 'true')
    end
  end

  describe "RHEL" do
    let :facts do
      {
          :osfamily => 'RedHat',
          :operatingsystem => 'RedHat',
      }
    end

    it 'should call the plugin' do
      should contain_foreman__plugin('tasks').with_package('ruby193-rubygem-foreman-tasks')
      should contain_service('foreman-tasks').with('ensure' => 'running', 'enable' => 'true')
    end
  end

  describe "Debian" do
    let :facts do
      {
          :osfamily => 'Debian',
      }
    end

    it 'should fail' do
      should raise_error(Puppet::Error, /foreman-tasks does not support osfamily/)
    end
  end
end
