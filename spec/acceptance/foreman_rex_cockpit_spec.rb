require 'spec_helper_acceptance'

describe 'Scenario: install foreman', if: os[:family] == 'centos' do
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
    class { 'foreman':
      repo                   => 'nightly',
      user_groups            => [],
      initial_admin_username => 'admin',
      initial_admin_password => 'changeme',
      server_ssl_ca          => $certificate,
      server_ssl_chain       => $certificate,
      server_ssl_cert        => $certificate,
      server_ssl_key         => $key,
      server_ssl_crl         => '',
    }
    include foreman::plugin::remote_execution::cockpit
    EOS
  end

  it_behaves_like 'a idempotent resource'

  describe service(apache_service_name) do
    it { is_expected.to be_enabled }
    it { is_expected.to be_running }
  end

  describe service('dynflow-sidekiq@orchestrator') do
    it { is_expected.to be_enabled }
    it { is_expected.to be_running }
  end

  describe service('dynflow-sidekiq@worker') do
    it { is_expected.to be_enabled }
    it { is_expected.to be_running }
  end

  describe service('foreman') do
    it { is_expected.to be_enabled }
    it { is_expected.to be_running }
  end

  describe port(80) do
    it { is_expected.to be_listening }
  end

  describe port(443) do
    it { is_expected.to be_listening }
  end

  describe port(19090) do
    it { is_expected.to be_listening.on('127.0.0.1').with('tcp') }
  end

  describe command("curl -s --cacert /etc/foreman/certificate.pem https://#{host_inventory['fqdn']} -w '\%{redirect_url}' -o /dev/null") do
    its(:stdout) { is_expected.to eq("https://#{host_inventory['fqdn']}/users/login") }
    its(:exit_status) { is_expected.to eq 0 }
  end
end
