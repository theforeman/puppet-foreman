require 'spec_helper_acceptance'

describe 'Scenario: install foreman with statsd' do
  let(:pp) do
    <<-EOS
    # Workarounds

    ## Ensure repos are present before installing
    Yumrepo <| |> -> Package <| |>

    ## We want passenger from EPEL
    class { '::apache::mod::passenger':
      manage_repo => false,
    }

    $directory = '/etc/foreman'
    $certificate = "${directory}/certificate.pem"
    $key = "${directory}/key.pem"
    exec { 'Create certificate directory':
      command => "mkdir -p ${directory}",
      path    => ['/bin', '/usr/bin'],
      creates => $directory,
    } ->
    exec { 'Generate certificate':
      command => "openssl req -nodes -x509 -newkey rsa:2048 -subj '/CN=${facts['fqdn']}' -keyout '${key}' -out '${certificate}' -days 365",
      path    => ['/bin', '/usr/bin'],
      creates => $certificate,
      umask   => '0022',
    } ->
    file { [$key, $certificate]:
      owner => 'root',
      group => 'root',
      mode  => '0640',
    } ->
    class { '::foreman':
      repo                     => 'nightly',
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

  include_examples 'foreman via passenger'

  describe package('foreman-telemetry') do
    it { is_expected.to be_installed }
  end

  # TODO: actually verify statsd functionality
end
