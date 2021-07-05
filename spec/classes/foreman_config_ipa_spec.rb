require 'spec_helper'

describe 'foreman' do
  on_supported_os.each do |os, facts|
    context "on #{os}", if: facts[:osfamily] == 'RedHat' do
      let(:facts) { facts.merge(interfaces: '') }
      let(:params) { { ipa_authentication: true } }

      describe 'without apache' do
        let(:params) { super().merge(apache: false) }
        it { should raise_error(Puppet::Error, /External authentication via IPA can only be enabled when Apache is used/) }
      end

      context 'with apache' do
        let(:params) { super().merge(apache: true) }

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
              foreman_ipa: {
                default_server: 'ipa.example.com',
                default_realm: 'REALM'
              },
              foreman_sssd: {
                services: ['ifp']
              }
            )
          end

          it { should contain_exec('ipa-getkeytab') }
          it { should contain_class('apache::mod::authnz_pam') }
          it { should contain_class('apache::mod::intercept_form_submit') }
          it { should contain_class('apache::mod::lookup_identity') }
          it { should contain_class('apache::mod::auth_gssapi') }

          it 'should contain Apache fragments' do
            should contain_foreman__config__apache__fragment('intercept_form_submit')
              .with_ssl_content(/^\s*InterceptFormPAMService foreman$/)

            should contain_foreman__config__apache__fragment('lookup_identity')

            should contain_foreman__config__apache__fragment('auth_gssapi')
              .with_ssl_content(%r{^\s*GssapiCredStore keytab:/etc/httpd/conf/http.keytab$})
              .with_ssl_content(/^\s*require pam-account foreman$/)
          end

          context 'with SELinux' do
            let(:facts) { override_facts(super(), os: {'selinux' => {'enabled' => selinux}}) }

            context 'enabled' do
              let(:selinux) { true }

              it { should contain_selboolean('allow_httpd_mod_auth_pam') }
              it { should contain_selboolean('httpd_dbus_sssd') }
            end

            context 'disabled' do
              let(:selinux) { false }

              it { should_not contain_selboolean('allow_httpd_mod_auth_pam') }
              it { should_not contain_selboolean('httpd_dbus_sssd') }
            end
          end
        end
      end
    end
  end
end
