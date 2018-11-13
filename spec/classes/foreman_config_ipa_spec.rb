require 'spec_helper'

describe 'foreman' do
  on_os_under_test.each do |os, facts|
    context "on #{os}", if: facts[:osfamily] == 'RedHat' do
      let(:facts) { facts.merge(interfaces: '') }
      let(:params) { { ipa_authentication: true } }

      describe 'without passenger' do
        let(:params) { super().merge(passenger: false) }
        it { should raise_error(Puppet::Error, /External authentication via IPA can only be enabled when passenger is used/) }
      end

      context 'with passenger' do
        let(:params) { super().merge(passenger: true) }

        describe 'not IPA-enrolled system' do
          describe 'ipa_server fact missing' do
            it { should raise_error(Puppet::Error, /The system does not seem to be IPA-enrolled/) }
          end

          describe 'default_ipa_realm fact missing' do
            it { should raise_error(Puppet::Error, /The system does not seem to be IPA-enrolled/) }
          end
        end

        describe 'enrolled system' do
          let(:facts) do
            super().merge(
              ipa: {
                default_server: 'ipa.example.com',
                default_realm: 'REALM'
              },
              sssd: {
                services: ['ifp']
              }
            )
          end

          it { should contain_exec('ipa-getkeytab') }
          it { should contain_class('apache::mod::authnz_pam') }
          it { should contain_class('apache::mod::intercept_form_submit') }
          it { should contain_class('apache::mod::lookup_identity') }
          it { should contain_class('apache::mod::auth_kerb') }

          it 'should contain Apache fragments' do
            should contain_foreman__config__apache__fragment('intercept_form_submit')
              .with_ssl_content(/^\s*InterceptFormPAMService foreman$/)

            should contain_foreman__config__apache__fragment('lookup_identity')

            should contain_foreman__config__apache__fragment('auth_kerb')
              .with_ssl_content(/^\s*KrbAuthRealms REALM$/)
              .with_ssl_content(%r{^\s*Krb5KeyTab /etc/httpd/conf/http.keytab$})
              .with_ssl_content(/^\s*require pam-account foreman$/)
          end

          describe 'on non-selinux' do
            let(:facts) { super().merge(selinux: false) }
            it { should_not contain_selboolean('httpd_dbus_sssd') }
          end

          context 'on selinux system' do
            let(:facts) { super().merge(selinux: true) }

            describe 'with disabled by user' do
              let(:params) { super().merge(selinux: false) }
              it { should_not contain_selboolean('httpd_dbus_sssd') }
            end

            describe 'with enabled by user' do
              let(:params) { super().merge(selinux: true) }
              it { should contain_selboolean('httpd_dbus_sssd') }
            end

            describe 'with automatic' do
              it { should contain_selboolean('httpd_dbus_sssd') }
            end
          end
        end
      end
    end
  end
end
