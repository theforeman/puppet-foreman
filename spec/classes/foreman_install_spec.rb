require 'spec_helper'

describe 'foreman::install' do
  let :default_facts do
    {
      :concat_basedir           => '/tmp',
      :interfaces               => '',
      :postgres_default_version => '8.4',
    }
  end

  context 'RedHat' do
    let :facts do
      default_facts.merge({
        :operatingsystem => 'RedHat',
        :osfamily        => 'RedHat',
      })
    end

    describe 'without parameters' do
      let :pre_condition do
        "class {'foreman':}"
      end

      it { should contain_foreman__install__repos('foreman') }

      it { should contain_package('foreman-postgresql').with_require('Foreman::Install::Repos[foreman]') }
    end

    describe 'with custom repo' do
      let :pre_condition do
        "class {'foreman':
          custom_repo => true,
        }"
      end

      it { should_not contain_foreman__install__repos('foreman') }

      it { should contain_package('foreman-postgresql').with_require([]) }
    end

    describe 'with sqlite' do
      let :pre_condition do
        "class {'foreman':
          db_type => 'sqlite',
         }"
      end

      it { should contain_package('foreman-sqlite').with_require('Foreman::Install::Repos[foreman]') }
    end

    describe 'with postgresql' do
      let :pre_condition do
        "class {'foreman':
          db_type => 'postgresql',
         }"
      end

      it { should contain_package('foreman-postgresql').with_require('Foreman::Install::Repos[foreman]') }
    end

    describe 'with mysql' do
      let :pre_condition do
        "class {'foreman':
          db_type => 'mysql',
         }"
      end

      it { should contain_package('foreman-mysql').with_require('Foreman::Install::Repos[foreman]') }
    end
  end

  context 'on debian' do
    let :facts do
      default_facts.merge({
        :operatingsystem => 'Debian',
        :osfamily        => 'Debian',
      })
    end

    describe 'without parameters' do
      let :pre_condition do
        "class {'foreman':}"
      end

      it { should contain_foreman__install__repos('foreman') }

      it { should contain_package('foreman-postgresql').with_require('Foreman::Install::Repos[foreman]') }
    end

    describe 'with custom repo' do
      let :pre_condition do
        "class {'foreman':
          custom_repo => true,
        }"
      end

      it { should_not contain_foreman__install__repos('foreman') }

      it { should contain_package('foreman-postgresql').with_require([]) }
    end

    describe 'with sqlite' do
      let :pre_condition do
        "class {'foreman':
          db_type => 'sqlite',
         }"
      end

      it { should contain_package('foreman-sqlite3').with_require('Foreman::Install::Repos[foreman]') }
    end

    describe 'with postgresql' do
      let :pre_condition do
        "class {'foreman':
          db_type => 'postgresql',
         }"
      end

      it { should contain_package('foreman-postgresql').with_require('Foreman::Install::Repos[foreman]') }
    end

    describe 'with mysql' do
      let :pre_condition do
        "class {'foreman':
          db_type => 'mysql',
         }"
      end

      it { should contain_package('foreman-mysql').with_require('Foreman::Install::Repos[foreman]') }
    end
  end
end
