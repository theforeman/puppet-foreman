require 'spec_helper_acceptance'

describe 'Scenario: install foreman with prometheus' do
  apache_service_name = ['debian', 'ubuntu'].include?(os[:family]) ? 'apache2' : 'httpd'

  before(:context) do
    case fact('osfamily')
    when 'RedHat'
      on default, 'yum -y remove foreman* tfm-* && rm -rf /etc/yum.repos.d/foreman*.repo'
    when 'Debian'
      on default, 'apt-get purge -y foreman*', { :acceptable_exit_codes => [0, 100] }
      on default, 'apt-get purge -y ruby-hammer-cli-*', { :acceptable_exit_codes => [0, 100] }
      on default, 'rm -rf /etc/apt/sources.list.d/foreman*'
    end

    on default, "systemctl stop #{apache_service_name}", { :acceptable_exit_codes => [0, 5] }
  end

  let(:pp) do
    <<-EOS
    if $facts['os']['family'] == 'RedHat' and $facts['os']['name'] != 'Fedora' {
      class { 'redis::globals':
        scl => 'rh-redis5',
      }
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
      repo                         => 'nightly',
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
