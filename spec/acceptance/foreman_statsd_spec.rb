require 'spec_helper_acceptance'

describe 'Scenario: install foreman with statsd' do
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
      user_groups              => [],
      initial_admin_username   => 'admin',
      initial_admin_password   => 'changeme',
      server_ssl_ca            => $certificate,
      server_ssl_chain         => $certificate,
      server_ssl_cert          => $certificate,
      server_ssl_key           => $key,
      server_ssl_crl           => '',
      telemetry_statsd_enabled => true,
    }
    EOS
  end

  it_behaves_like 'a idempotent resource'

  it_behaves_like 'the foreman application'

  describe package('foreman-telemetry') do
    it { is_expected.to be_installed }
  end

  # TODO: actually verify statsd functionality
end
