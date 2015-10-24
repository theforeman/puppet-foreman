require 'spec_helper'

describe 'foreman::install' do
  on_supported_os.each do |os, facts|
    next if only_test_os() and not only_test_os.include?(os)
    next if exclude_test_os() and exclude_test_os.include?(os)

    context "on #{os}" do
      let :facts do
        facts.merge({
          :concat_basedir => '/tmp',
        })
      end

      describe 'without parameters' do
        let :pre_condition do
          "class {'foreman':}"
        end

        case facts[:osfamily]
        when 'RedHat'
          configure_scl_repo = (facts[:operatingsystem] != 'RedHat' and facts[:operatingsystem] != 'Fedora')

          it { should contain_foreman__install__repos('foreman') }
          it { should contain_class('foreman::install::repos::extra').with({
            :configure_scl_repo       => configure_scl_repo,
            :configure_epel_repo      => facts[:operatingsystem] != 'Fedora',
            :configure_brightbox_repo => false,
          })}

          it { should contain_package('foreman-postgresql').with_ensure('present') }
          it { should contain_package('foreman-postgresql').that_requires('Foreman::Install::Repos[foreman]') }
          it { should contain_package('foreman-postgresql').that_requires('Class[foreman::install::repos::extra]') }

          if facts[:operatingsystem] != 'Fedora'
            it { should contain_package('tfm-rubygem-passenger-native') }
          end
        when 'Debian'
          configure_brightbox_repo = os == 'ubuntu-12-x86_64'

          it { should contain_foreman__install__repos('foreman') }
          it { should contain_class('foreman::install::repos::extra').with({
            :configure_scl_repo       => false,
            :configure_epel_repo      => false,
            :configure_brightbox_repo => configure_brightbox_repo,
          })}

          it { should contain_package('foreman-postgresql').with_ensure('present') }
          it { should contain_package('foreman-postgresql').that_requires('Foreman::Install::Repos[foreman]') }
          it { should contain_package('foreman-postgresql').that_requires('Class[foreman::install::repos::extra]') }

          if configure_brightbox_repo
            it { should contain_package('passenger-common1.9.1') }
          end
        end
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

        case facts[:osfamily]
        when 'RedHat'
          it { should contain_package('foreman-sqlite').that_requires('Foreman::Install::Repos[foreman]') }
          it { should contain_package('foreman-sqlite').that_requires('Class[foreman::install::repos::extra]') }
        when 'Debian'
          it { should contain_package('foreman-sqlite3').that_requires('Foreman::Install::Repos[foreman]') }
          it { should contain_package('foreman-sqlite3').that_requires('Class[foreman::install::repos::extra]') }
        end
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

      if facts[:osfamily] == 'RedHat'
        context 'with SELinux enabled' do
          let :facts do
            facts.merge({
              :concat_basedir => '/tmp',
              :selinux        => true,
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
            facts.merge({
              :concat_basedir => '/tmp',
              :selinux        => false,
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
    end
  end
end
