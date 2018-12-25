require 'spec_helper_acceptance'

describe 'Scenario: install foreman with statsd' do
  before(:context) do
    case fact('osfamily')
    when 'RedHat'
      on default, 'yum -y remove foreman* tfm-* && rm -rf /etc/yum.repos.d/foreman*.repo'
      on default, 'service httpd stop', { :acceptable_exit_codes => [0, 5] }
    when 'Debian'
      on default, 'apt-get purge -y foreman*', { :acceptable_exit_codes => [0, 100] }
      on default, 'apt-get purge -y ruby-hammer-cli-*', { :acceptable_exit_codes => [0, 100] }
      on default, 'rm -rf /etc/apt/sources.list.d/foreman*'
      on default, 'service apache2 stop', { :acceptable_exit_codes => [0, 5] }
    end
  end

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
      admin_username           => 'admin',
      admin_password           => 'changeme',
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

  describe service(os[:family] == 'debian' ? 'apache2' : 'httpd') do
    it { is_expected.to be_enabled }
    it { is_expected.to be_running }
  end

  describe service('dynflowd') do
    it { is_expected.to be_enabled }
    it { is_expected.to be_running }
  end

  describe package('foreman-telemetry') do
    it { is_expected.to be_installed }
  end

  describe port(80) do
    it { is_expected.to be_listening }
  end

  describe port(443) do
    it { is_expected.to be_listening }
  end

  describe command("curl -s --cacert /etc/foreman/certificate.pem https://#{host_inventory['fqdn']} -w '\%{redirect_url}' -o /dev/null") do
    its(:stdout) { is_expected.to eq("https://#{host_inventory['fqdn']}/users/login") }
  end

  # TODO: actually verify statsd functionality
end
