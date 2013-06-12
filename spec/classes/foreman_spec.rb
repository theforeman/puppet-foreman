require 'spec_helper'


describe 'foreman' do
  let :default_facts do
    {
      :concat_basedir           => '/tmp',
      :interfaces               => '',
      :postgres_default_version => '8.4',
    }
  end

  context 'on redhat' do
    let :facts do
      default_facts.merge({
        :operatingsystem => 'RedHat',
        :osfamily        => 'RedHat',
      })
    end

    it { should include_class('foreman::install') }
    it { should include_class('foreman::config') }
    it { should include_class('foreman::database') }
    it { should include_class('foreman::service') }
  end

  context 'on debian' do
    let :facts do
      default_facts.merge({
        :operatingsystem => 'Debian',
        :osfamily        => 'Debian',
      })
    end

    it { should include_class('foreman::install') }
    it { should include_class('foreman::config') }
    it { should include_class('foreman::database') }
    it { should include_class('foreman::service') }
  end
end
