require 'spec_helper'

describe 'foreman::rake' do
  let :default_facts do
    {
      :concat_basedir => '/tmp',
      :interfaces     => '',
    }
  end

  let :pre_condition do
    "class { 'foreman':
      db_manage => false,
     }"
  end

  let(:title) { 'db:migrate' }

  context 'on RedHat' do
    let :facts do
      default_facts.merge({
        :operatingsystem        => 'RedHat',
        :operatingsystemrelease => '6.4',
        :osfamily               => 'RedHat',
      })
    end

    it { should contain_exec('foreman-rake-db:migrate').with({
      'command'     => '/usr/sbin/foreman-rake db:migrate && /bin/touch /var/lib/foreman/db:migrate_done',
      'provider'    => 'shell',
      'user'        => 'foreman',
      'environment' => 'HOME=/usr/share/foreman',
      'logoutput'   => 'on_failure',
      'creates'     => '/var/lib/foreman/db:migrate_done'
    })}
  end
end
