require 'spec_helper'


describe 'foreman' do
  let :default_facts do
    {
      :concat_basedir => '/tmp',
      :interfaces     => '',
      :puppet_vardir  => '/tmp',
      :id             => 'root',
      :path           => '/tmp',
      :kernel         => 'Linux',
    }
  end

  context 'on redhat' do
    let :facts do
      default_facts.merge({
        :operatingsystem        => 'RedHat',
        :operatingsystemrelease => '6.4',
        :osfamily               => 'RedHat',
        :rubyversion            => '1.8.7',
        :selinux                => 'true',
        :lsbdistcodename        => 'Santiago',
      })
    end

    it { should contain_class('foreman::install') }
    it { should contain_class('foreman::config') }
    it { should contain_class('foreman::database') }
    it { should contain_class('foreman::service') }
  end

  context 'on debian' do
    let :facts do
      default_facts.merge({
        :operatingsystem        => 'Debian',
        :operatingsystemrelease => 'wheezy',
        :osfamily               => 'Debian',
        :lsbdistcodename        => 'wheezy',
        :selinux                => 'false',
      })
    end

    it { should contain_class('foreman::install') }
    it { should contain_class('foreman::config') }
    it { should contain_class('foreman::database') }
    it { should contain_class('foreman::service') }
  end
end
