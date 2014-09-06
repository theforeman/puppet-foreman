require 'spec_helper'

describe 'foreman::install' do
  let :default_facts do
    {
      :concat_basedir => '/tmp',
      :interfaces     => '',
    }
  end

  context 'RedHat' do
    let :facts do
      default_facts.merge({
        :operatingsystem        => 'RedHat',
        :operatingsystemrelease => '6.4',
        :osfamily               => 'RedHat',
      })
    end

    describe 'without parameters' do
      let :pre_condition do
        "class {'foreman':}"
      end

      it { should contain_class('foreman::database::postgresql') }

      it { should contain_foreman__rake('db:migrate') }
      it { should contain_foreman__rake('db:seed') }
      it { should contain_foreman__rake('apipie:cache') }
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
  end

  context 'on debian' do
    let :facts do
      default_facts.merge({
        :operatingsystem        => 'Debian',
        :operatingsystemrelease => 'wheezy',
        :osfamily               => 'Debian',
      })
    end

    describe 'without parameters' do
      let :pre_condition do
        "class {'foreman':}"
      end

      it { should contain_class('foreman::database::postgresql') }

      it { should contain_foreman__rake('db:migrate') }
      it { should contain_foreman__rake('db:seed') }
      it { should contain_foreman__rake('apipie:cache') }
    end
  end
end
