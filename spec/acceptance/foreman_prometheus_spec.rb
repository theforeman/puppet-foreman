require 'spec_helper_acceptance'

describe 'Scenario: install foreman with prometheus' do
  before(:context) { purge_foreman }

  let(:pp) do
    <<-EOS
    if $facts['os']['family'] == 'RedHat' and $facts['os']['name'] != 'Fedora' {
      class { 'redis::globals':
        scl => 'rh-redis5',
      }
    }

    $directory = '/etc/foreman-certs'
    $certificate = "${directory}/certificate.pem"
    $key = "${directory}/key.pem"

    class { 'foreman':
      user_groups                  => [],
      initial_admin_username       => 'admin',
      initial_admin_password       => 'changeme',
      server_ssl_ca                => $certificate,
      server_ssl_chain             => $certificate,
      server_ssl_cert              => $certificate,
      server_ssl_key               => $key,
      server_ssl_crl               => '',
      telemetry_prometheus_enabled => true,
    }
    EOS
  end

  it_behaves_like 'a idempotent resource'

  describe package('foreman-telemetry') do
    it { is_expected.to be_installed }
  end

  it_behaves_like 'the foreman application'

  # TODO: actually verify prometheus functionality
end
