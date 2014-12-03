require 'spec_helper'

describe 'foreman::config' do

  on_supported_os.each do |os, facts|
    if facts[:osfamily] == 'RedHat'
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

          it('should not integrate ipa') { should_not contain_exec('ipa-getkeytab') }
        end

        # we don't allow ipa on non-passenger env
        describe 'with freeipa enabled' do
          let :pre_condition do
            "class {'foreman':
             passenger => false,
             ipa_authentication => true,
           }"
          end

          it "will fail" do
            should raise_error(Puppet::Error, /External authentication via IPA can only be enabled when passenger is used/)
          end
        end

        describe 'with passenger and ipa' do
          let :pre_condition do
            "class {'foreman':
            passenger => true,
            ipa_authentication => true,
          }"
          end

          describe 'not IPA-enrolled system' do
            describe 'ipa_server fact missing' do
              it "will fail" do
                expect {
                  should contain_exec('ipa-getkeytab')
                }.to raise_error(Puppet::Error, /The system does not seem to be IPA-enrolled/)
              end
            end

            describe 'default_ipa_realm fact missing' do
              it "will fail" do
                expect {
                  should contain_exec('ipa-getkeytab')
                }.to raise_error(Puppet::Error, /The system does not seem to be IPA-enrolled/)
              end
            end
          end

          describe 'enrolled system' do
            let :facts do
              facts.merge({
                :concat_basedir => '/tmp',
                :interfaces     => '',
                :default_ipa_server => 'ipa.example.com',
                :default_ipa_realm => 'REALM',
              })
            end

            it { should contain_exec('ipa-getkeytab') }

            describe 'on non-selinux' do
              let :facts do
                facts.merge({
                  :concat_basedir => '/tmp',
                  :interfaces     => '',
                  :default_ipa_server => 'ipa.example.com',
                  :default_ipa_realm => 'REALM',
                  :selinux => 'false',
                })
              end

              it { should_not contain_exec('setsebool httpd_dbus_sssd') }
            end

            describe 'on selinux system but disabled by user' do
              let :facts do
                facts.merge({
                  :concat_basedir => '/tmp',
                  :interfaces     => '',
                  :default_ipa_server => 'ipa.example.com',
                  :default_ipa_realm => 'REALM',
                  :selinux => 'true',
                })
              end

              let :pre_condition do
                "class {'foreman':
              passenger => true,
              ipa_authentication => true,
              selinux => false,
            }"
              end

              it { should_not contain_exec('setsebool httpd_dbus_sssd') }
            end

            describe 'on selinux system with enabled by user' do
              let :facts do
                facts.merge({
                  :concat_basedir => '/tmp',
                  :interfaces     => '',
                  :default_ipa_server => 'ipa.example.com',
                  :default_ipa_realm => 'REALM',
                  :selinux => 'true',
                })
              end

              let :pre_condition do
                "class {'foreman':
              passenger => true,
              ipa_authentication => true,
              selinux => true,
            }"
              end

              it { should contain_exec('setsebool httpd_dbus_sssd') }
            end

            describe 'on selinux' do
              let :facts do
                facts.merge({
                  :concat_basedir => '/tmp',
                  :interfaces     => '',
                  :default_ipa_server => 'ipa.example.com',
                  :default_ipa_realm => 'REALM',
                  :selinux => 'true',
                })
              end

              it { should contain_exec('setsebool httpd_dbus_sssd') }
            end
          end
        end
      end
    end
  end
end
