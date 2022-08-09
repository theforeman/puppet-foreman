require 'spec_helper_acceptance'

describe 'Foreman using external authentication' do
  before(:context) { purge_foreman }

  describe 'with ipa_authentication' do
    it_behaves_like 'an idempotent resource' do
      let(:manifest) do
        <<~PUPPET
        $http_keytab = '/etc/foreman.keytab'
        exec { 'stub out keytab':
          command => "/usr/bin/touch ${http_keytab}",
          creates => $http_keytab,
        } ->
        file { '/etc/sssd':
          ensure => directory,
        } ->
        file { '/etc/sssd/sssd.conf':
          ensure  => file,
          content => "[domain/$facts['domain']}]\n",
          replace => false,
        } ->
        class { 'foreman':
          http_keytab        => $http_keytab,
          ipa_authentication => true,
          ipa_manage_sssd    => false, # sssd doesn't like our mocked sssd.conf
        }
        PUPPET
      end
    end

    it_behaves_like 'the basic foreman application'

    describe command("curl -s --cacert /etc/foreman-certs/certificate.pem https://#{host_inventory['fqdn']} -w '\%{redirect_url}' -o /dev/null") do
      its(:stdout) { is_expected.to eq("https://#{host_inventory['fqdn']}/users/extlogin") }
      its(:exit_status) { is_expected.to eq 0 }
    end
  end

  describe 'with keycloak' do
    it_behaves_like 'an idempotent resource' do
      let(:manifest) do
        <<~PUPPET
        $servername = $facts['fqdn']
        $keycloak_app_name = 'foreman-openidc'
        $keycloak_realm = 'ssl-realm'

        # taken from /usr/share/keycloak-httpd-client-install/templates/oidc_httpd.conf
        $keycloak_content = @(KEYCLOAK)
        OIDCClientID ${servername}-${keycloak_app_name}
        OIDCProviderMetadataURL https://keycloak.example.com/auth/realms/${keycloak_realm}/.well-known/openid-configuration
        OIDCCryptoPassphrase PASSPHRASE
        OIDCClientSecret SECRET
        OIDCRedirectURI https://${servername}/users/extlogin/redirect_uri
        OIDCRemoteUserClaim sub

        <Location /users/extlogin>
            AuthType openid-connect
            Require valid-user
        </Location>
        KEYCLOAK

        include apache
        $keycloak_config = "${apache::confd_dir}/${keycloak_app_name}_oidc_keycloak_${keycloak_realm}.conf"

        # mimic keycloak-httpd-client-install
        file { '/etc/keycloak.conf':
          ensure  => file,
          content => $keycloak_content,
        } ->
        exec { 'stub out keycloak':
          command => "/bin/cp /etc/keycloak.conf ${keycloak_config}",
          creates => $keycloak_config,
        } ->
        class { 'foreman':
          keycloak => true,
          keycloak_app_name => $keycloak_app_name,
          keycloak_realm    => $keycloak_realm,
        }
        PUPPET
      end
    end

    it_behaves_like 'the foreman application'
  end
end
