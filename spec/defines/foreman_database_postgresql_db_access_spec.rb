require 'spec_helper'

describe 'foreman::database::postgresql::db_access' do
  let(:title) { 'foreman' }

  on_os_under_test.each do |os, facts|
    context "on #{os}" do
      let :facts do
        facts
      end

      context 'as master' do
        let :pre_condition do
          "class { '::foreman':
              db_database          => 'foreman',
              db_username          => 'foreman',
              db_cluster_hostnames => ['vip.example.com'],
              db_host              => 'vip.example.com',
              db_node_type         => 'master',
          }"
        end

        it { is_expected.to contain_class('foreman::database::postgresql::master') }

        it { should contain_postgresql__server__pg_hba_rule("allow vip.example.com access to foreman database").with({
          :type        => 'host',
          :database    => 'foreman',
          :user        => 'foreman',
          :address     => 'vip.example.com',
          :auth_method => 'md5',
        }) }

        it { should contain_postgresql__server__pg_hba_rule("allow replication from vip.example.com").with({
         :type        => 'host',
         :database    => 'replication',
         :user        => 'foreman-replicator',
         :address     => 'vip.example.com',
         :auth_method => 'md5',
        }) }
      end

      context 'as slave' do
        let :pre_condition do
          "class { '::foreman':
              db_database          => 'foreman',
              db_username          => 'foreman',
              db_cluster_hostnames => ['vip.example.com'],
              db_host              => 'vip.example.com',
              db_node_type         => 'slave',
          }"
        end

        it { is_expected.to contain_class('foreman::database::postgresql::slave') }

        it { should contain_postgresql__server__pg_hba_rule("allow vip.example.com access to foreman database").with({
          :type        => 'host',
          :database    => 'foreman',
          :user        => 'foreman',
          :address     => 'vip.example.com',
          :auth_method => 'md5',
        }) }

        it { should contain_postgresql__server__pg_hba_rule("allow replication from vip.example.com").with({
         :type        => 'host',
         :database    => 'replication',
         :user        => 'foreman-replicator',
         :address     => 'vip.example.com',
         :auth_method => 'md5',
        }) }
      end
    end
  end
end
