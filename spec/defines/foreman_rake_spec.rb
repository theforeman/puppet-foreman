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
      'command'     => '/usr/sbin/foreman-rake db:migrate',
      'user'        => 'foreman',
      'environment' => 'HOME=/usr/share/foreman',
      'logoutput'   => 'on_failure',
      'refreshonly' => true,
    })}

    context 'with environment' do
      let(:params) { {'environment' => {'SEED_USER' => 'admin'}} }
      it { should contain_exec('foreman-rake-db:migrate').with({
        'command'     => '/usr/sbin/foreman-rake db:migrate',
        'user'        => 'foreman',
        'environment' => ['HOME=/usr/share/foreman', 'SEED_USER=admin'],
        'logoutput'   => 'on_failure',
        'refreshonly' => true,
        'timeout'     => nil,
      })}
    end

    context 'with timeout' do
      let(:params) { {'timeout' => 60 }}
      it { should contain_exec('foreman-rake-db:migrate').with({
        'command'     => '/usr/sbin/foreman-rake db:migrate',
        'user'        => 'foreman',
        'environment' => ['HOME=/usr/share/foreman'],
        'timeout'     => 60,
        'logoutput'   => 'on_failure',
        'refreshonly' => true,
      })}
    end
  end
end
