require 'spec_helper'

describe 'foreman::install' do

  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts.merge({
          :concat_basedir => '/tmp',
          :interfaces     => '',
        })
      end

      describe 'without parameters' do
        let :pre_condition do
          "class {'foreman':}"
        end

        it { should contain_class('foreman::database::postgresql') }

        it { should contain_foreman_config_entry('db_pending_migration') }
        it { should contain_foreman__rake('db:migrate') }
        it { should contain_foreman_config_entry('db_pending_seed') }
        it { should contain_foreman__rake('db:seed') }
        it { should contain_foreman__rake('apipie:cache:index') }
      end

      describe 'with seed parameters' do
        let :pre_condition do
          "class {'foreman':
           admin_username => 'joe',
           admin_password => 'secret',
         }"
        end

        it {
          should contain_foreman__rake('db:seed').
          with_environment({
            'SEED_ADMIN_USER'     => 'joe',
            'SEED_ADMIN_PASSWORD' => 'secret',
          })
        }
      end

      describe 'with apipie_task' do
        let :pre_condition do
          "class {'foreman':
             apipie_task => 'apipie:cache',
           }"
        end
        it { should contain_foreman__rake('apipie:cache') }
      end

      describe 'with mysql db_type' do
        let :pre_condition do
          "class { 'foreman':
            db_type => 'mysql'
          }"
        end

        it { should_not contain_class('foreman::database::postgresql') }
        it { should contain_class('foreman::database::mysql') }
        it { should contain_class('mysql::server') }
        it { should contain_class('mysql::server::account_security') }
        it {
          should contain_mysql__db('foreman').with({
            :user => 'foreman',
          })
        }
      end
    end
  end
end
