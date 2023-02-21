require 'spec_helper_acceptance'

describe 'Foreman' do
  before(:context) { purge_foreman }

  describe 'with default options' do
    it_behaves_like 'an idempotent resource' do
      let(:manifest) { 'include foreman' }
    end

    it_behaves_like 'the foreman application'

    describe package('foreman-journald') do
      it { is_expected.not_to be_installed }
    end

    describe package('foreman-telemetry') do
      it { is_expected.not_to be_installed }
    end
  end

  describe 'with Redis caching' do
    it_behaves_like 'an idempotent resource' do
      let(:manifest) do
        <<~PUPPET
        class { 'foreman':
          rails_cache_store => { 'type' => 'redis' },
        }
        PUPPET
      end
    end

    it_behaves_like 'the foreman application'

    # TODO: verify it works using the /api/ping endpoint
    # https://projects.theforeman.org/issues/36113
  end

  context 'GSSAPI auth enabled' do
    before { on default, 'mkdir -p /etc/httpd && touch /etc/httpd/conf.keytab' }

    it_behaves_like 'an idempotent resource' do
      let(:manifest) do
        <<-PUPPET
        class { 'foreman':
          ipa_authentication     => true,
          ipa_authentication_api => true,
          # Stub out ipa enrollment
          http_keytab            => '/etc/httpd/conf.keytab',
          ipa_manage_sssd        => false,
        }
        PUPPET
      end
    end

    it_behaves_like 'the foreman application', { expected_login_url_path: '/users/extlogin' }
  end
end
