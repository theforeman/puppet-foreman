require 'spec_helper'

describe 'foreman' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) { facts.merge(interfaces: '') }
      let(:params) { { external_authentication: 'ipa' } }

      keytab_path = facts[:os]['family'] == 'RedHat' ? '/etc/httpd/conf/http.keytab' : '/etc/apache2/http.keytab'

      describe 'without apache' do
        let(:params) { super().merge(apache: false) }
        it { should compile.and_raise_error(/External authentication can only be enabled when Apache is used/) }
      end

      context 'with apache' do
        let(:params) { super().merge(apache: true) }

        describe 'enrolled system' do
          let(:facts) do
            super().merge(
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
          it { should contain_class('apache::mod::auth_basic') }

          it 'should contain Apache fragments' do
            should contain_foreman__config__apache__fragment('intercept_form_submit')
              .with_ssl_content(/^\s*InterceptFormPAMService foreman$/)

            should contain_foreman__config__apache__fragment('lookup_identity')

            should contain_foreman__config__apache__fragment('auth_gssapi')
              .with_ssl_content(%r{^\s*GssapiCredStore keytab:#{keytab_path}$})
              .with_ssl_content(/^\s*GssapiLocalName On$/)
              .with_ssl_content(/^\s*require pam-account foreman$/)

            should contain_foreman__config__apache__fragment('external_auth_api')
              .with_ssl_content(/^\s*AuthType Basic$/)
              .with_ssl_content(/^\s*AuthBasicProvider PAM$/)
              .with_ssl_content(/^\s*AuthPAMService foreman$/)
              .with_ssl_content(/^\s*require pam-account foreman$/)
              .without_ssl_content(/^\s*AuthType GSSAPI/)
          end

          context 'with gssapi_local_name=false' do
            let(:params) { super().merge(gssapi_local_name: false) }

            it 'should contain Apache fragments' do
              should contain_foreman__config__apache__fragment('auth_gssapi')
                .with_ssl_content(/^\s*GssapiLocalName Off$/)
            end
          end

          context 'with GSSAPI auth for API' do
            let(:params) { super().merge(external_authentication: 'ipa_with_api') }

            it 'should contain GSSAPI and Basic coniguration in API fragment' do
              should contain_foreman__config__apache__fragment('external_auth_api')
                .with_ssl_content(/^\s*AuthType Basic$/)
                .with_ssl_content(/^\s*AuthBasicProvider PAM$/)
                .with_ssl_content(/^\s*AuthPAMService foreman$/)
                .with_ssl_content(/^\s*require pam-account foreman$/)
                .with_ssl_content(/^\s*AuthType GSSAPI/)
                .with_ssl_content(/^\s*GssapiCredStore keytab:#{keytab_path}$/)
                .with_ssl_content(/^\s*GssapiLocalName On$/)
                .with_ssl_content(/^\s*require pam-account foreman$/)
            end
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
