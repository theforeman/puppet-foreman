require 'spec_helper'

describe 'foreman::install' do
  let :default_facts do
    {
      :concat_basedir => '/tmp',
      :interfaces     => '',
    }
  end

  context 'RHEL' do
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

      it { should contain_foreman__install__repos('foreman') }
      it { should contain_class('foreman::install::repos::extra').with({
        :configure_scl_repo       => false,
        :configure_epel_repo      => true,
        :configure_brightbox_repo => false,
      })}

      it { should contain_package('foreman-postgresql').with_ensure('present') }
      it { should contain_package('foreman-postgresql').that_requires('Foreman::Install::Repos[foreman]') }
      it { should contain_package('foreman-postgresql').that_requires('Class[foreman::install::repos::extra]') }
      it { should contain_package('ruby193-rubygem-passenger-native') }
    end

    describe 'with version' do
      let :pre_condition do
        "class {'foreman':
          version => 'latest',
        }"
      end

      it { should contain_foreman__install__repos('foreman') }

      it { should contain_package('foreman-postgresql').with_ensure('latest') }
      it { should contain_package('foreman-postgresql').that_requires('Foreman::Install::Repos[foreman]') }
    end

    describe 'with custom repo' do
      let :pre_condition do
        "class {'foreman':
          custom_repo => true,
        }"
      end

      it { should_not contain_foreman__install__repos('foreman') }

      it { should contain_package('foreman-postgresql').that_requires('Class[foreman::install::repos::extra]') }
    end

    describe 'with sqlite' do
      let :pre_condition do
        "class {'foreman':
          db_type => 'sqlite',
         }"
      end

      it { should contain_package('foreman-sqlite').that_requires('Foreman::Install::Repos[foreman]') }
      it { should contain_package('foreman-sqlite').that_requires('Class[foreman::install::repos::extra]') }
    end

    describe 'with postgresql' do
      let :pre_condition do
        "class {'foreman':
          db_type => 'postgresql',
         }"
      end

      it { should contain_package('foreman-postgresql').that_requires('Foreman::Install::Repos[foreman]') }
      it { should contain_package('foreman-postgresql').that_requires('Class[foreman::install::repos::extra]') }
    end

    describe 'with mysql' do
      let :pre_condition do
        "class {'foreman':
          db_type => 'mysql',
         }"
      end

      it { should contain_package('foreman-mysql2').that_requires('Foreman::Install::Repos[foreman]') }
      it { should contain_package('foreman-mysql2').that_requires('Class[foreman::install::repos::extra]') }
    end

    context 'with SELinux enabled' do
      let :facts do
        default_facts.merge({
          :operatingsystem        => 'RedHat',
          :operatingsystemrelease => '6.4',
          :osfamily               => 'RedHat',
          :selinux                => 'true',
        })
      end

      describe 'with selinux undef' do
        let :pre_condition do
          "class {'foreman': }"
        end
        it { should contain_package('foreman-selinux').that_requires('Foreman::Install::Repos[foreman]') }
        it { should contain_package('foreman-selinux').that_requires('Class[foreman::install::repos::extra]') }
      end

      describe 'with selinux false' do
        let :pre_condition do
          "class {'foreman':
             selinux => false,
           }"
        end
        it { should_not contain_package('foreman-selinux') }
      end

      describe 'with selinux true' do
        let :pre_condition do
          "class {'foreman':
             selinux => true,
           }"
        end
        it { should contain_package('foreman-selinux').that_requires('Foreman::Install::Repos[foreman]') }
        it { should contain_package('foreman-selinux').that_requires('Class[foreman::install::repos::extra]') }
      end
    end

    context 'with SELinux disabled' do
      let :facts do
        default_facts.merge({
          :operatingsystem        => 'RedHat',
          :operatingsystemrelease => '6.4',
          :osfamily               => 'RedHat',
          :selinux                => 'false',
        })
      end

      describe 'with selinux undef' do
        let :pre_condition do
          "class {'foreman': }"
        end
        it { should_not contain_package('foreman-selinux') }
      end

      describe 'with selinux false' do
        let :pre_condition do
          "class {'foreman':
             selinux => false,
           }"
        end
        it { should_not contain_package('foreman-selinux') }
      end

      describe 'with selinux true' do
        let :pre_condition do
          "class {'foreman':
             selinux => true,
           }"
        end
        it { should contain_package('foreman-selinux').that_requires('Foreman::Install::Repos[foreman]') }
        it { should contain_package('foreman-selinux').that_requires('Class[foreman::install::repos::extra]') }
      end
    end
  end

  context 'CentOS' do
    let :facts do
      default_facts.merge({
        :operatingsystem        => 'CentOS',
        :operatingsystemrelease => '6.4',
        :osfamily               => 'RedHat',
      })
    end

    describe 'without parameters' do
      let :pre_condition do
        "class {'foreman':}"
      end

      it { should contain_class('foreman::install::repos::extra').with({
        :configure_scl_repo       => true,
        :configure_epel_repo      => true,
        :configure_brightbox_repo => false,
      })}
    end
  end

  context 'Fedora' do
    let :facts do
      default_facts.merge({
        :operatingsystem        => 'Fedora',
        :operatingsystemrelease => '19',
        :osfamily               => 'RedHat',
      })
    end

    describe 'without parameters' do
      let :pre_condition do
        "class {'foreman':}"
      end

      it { should contain_class('foreman::install::repos::extra').with({
        :configure_scl_repo       => false,
        :configure_epel_repo      => false,
        :configure_brightbox_repo => false,
      })}
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

      it { should contain_foreman__install__repos('foreman') }
      it { should contain_class('foreman::install::repos::extra').with({
        :configure_scl_repo       => false,
        :configure_epel_repo      => false,
        :configure_brightbox_repo => false,
      })}

      it { should contain_package('foreman-postgresql').with_ensure('present') }
      it { should contain_package('foreman-postgresql').that_requires('Foreman::Install::Repos[foreman]') }
      it { should contain_package('foreman-postgresql').that_requires('Class[foreman::install::repos::extra]') }
    end

    describe 'with version' do
      let :pre_condition do
        "class {'foreman':
          version => 'latest',
        }"
      end

      it { should contain_foreman__install__repos('foreman') }

      it { should contain_package('foreman-postgresql').with_ensure('latest') }
      it { should contain_package('foreman-postgresql').that_requires('Foreman::Install::Repos[foreman]') }
      it { should contain_package('foreman-postgresql').that_requires('Class[foreman::install::repos::extra]') }
    end

    describe 'with custom repo' do
      let :pre_condition do
        "class {'foreman':
          custom_repo => true,
        }"
      end

      it { should_not contain_foreman__install__repos('foreman') }
      it { should contain_package('foreman-postgresql').that_requires('Class[foreman::install::repos::extra]') }
    end

    describe 'with sqlite' do
      let :pre_condition do
        "class {'foreman':
          db_type => 'sqlite',
         }"
      end

      it { should contain_package('foreman-sqlite3').that_requires('Foreman::Install::Repos[foreman]') }
      it { should contain_package('foreman-sqlite3').that_requires('Class[foreman::install::repos::extra]') }
    end

    describe 'with postgresql' do
      let :pre_condition do
        "class {'foreman':
          db_type => 'postgresql',
         }"
      end

      it { should contain_package('foreman-postgresql').that_requires('Foreman::Install::Repos[foreman]') }
      it { should contain_package('foreman-postgresql').that_requires('Class[foreman::install::repos::extra]') }
    end

    describe 'with mysql' do
      let :pre_condition do
        "class {'foreman':
          db_type => 'mysql',
         }"
      end

      it { should contain_package('foreman-mysql2').that_requires('Foreman::Install::Repos[foreman]') }
      it { should contain_package('foreman-mysql2').that_requires('Class[foreman::install::repos::extra]') }
    end
  end

  context 'on Ubuntu 12.04' do
    let :facts do
      default_facts.merge({
        :lsbdistid              => 'ubuntu',
        :lsbdistcodename        => 'precise',
        :operatingsystem        => 'Ubuntu',
        :operatingsystemrelease => '12.04',
        :osfamily               => 'Debian',
      })
    end

    describe 'without parameters' do
      let :pre_condition do
        "class {'foreman':}"
      end

      it { should contain_class('foreman::install::repos::extra').with({
        :configure_scl_repo       => false,
        :configure_epel_repo      => false,
        :configure_brightbox_repo => true,
      })}
      it { should contain_package('passenger-common1.9.1') }
    end
  end
end
