require 'spec_helper'

describe 'foreman' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) { facts }
      let(:params) { {} }

      describe 'with db_manage set to false' do
        let(:params) { super().merge(db_manage: false) }

        it { should_not contain_class('foreman::database::postgresql') }

        it { should contain_foreman__rake('db:migrate') }
        it { should contain_foreman_config_entry('db_pending_seed') }
        it { should contain_foreman__rake('db:seed') }
        it { should contain_foreman__rake('apipie:cache:index') }
      end

      describe 'with db_manage_rake set to false' do
        let(:params) { super().merge(db_manage_rake: false) }

        it { should compile.with_all_deps }
        it { should contain_class('foreman::database::postgresql') }

        it { should_not contain_foreman__rake('db:migrate') }
        it { should_not contain_foreman_config_entry('db_pending_seed') }
        it { should_not contain_foreman__rake('db:seed') }
      end

      describe 'with seed parameters' do
        let(:params) do
          super().merge(
            initial_admin_username: 'joe',
            initial_admin_password: 'secret'
          )
        end

        it do
          should contain_foreman__rake('db:seed')
            .with_environment(
              'SEED_ADMIN_USER' => 'joe',
              'SEED_ADMIN_PASSWORD' => 'secret'
            )
        end
      end
    end
  end
end
