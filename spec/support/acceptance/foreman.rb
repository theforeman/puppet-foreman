shared_examples 'foreman application' do
  apache_service_name = ['debian', 'ubuntu'].include?(os[:family]) ? 'apache2' : 'httpd'

  before(:context) do
    case fact('osfamily')
    when 'RedHat'
      on default, 'yum -y remove foreman* tfm-* mod_passenger'
      on default, 'rm -rf /etc/yum.repos.d/foreman*.repo'
    when 'Debian'
      on default, 'apt-get purge -y foreman*', { :acceptable_exit_codes => [0, 100] }
      on default, 'apt-get purge -y ruby-hammer-cli-*', { :acceptable_exit_codes => [0, 100] }
      on default, 'rm -rf /etc/apt/sources.list.d/foreman*'
    end

    on default, puppet('resource', 'service', apache_service_name, 'ensure=stopped')
  end

  it_behaves_like 'a idempotent resource'

  describe service(apache_service_name) do
    it { is_expected.to be_enabled }
    it { is_expected.to be_running }
  end

  describe service('dynflowd') do
    it { is_expected.to be_enabled }
    it { is_expected.to be_running }
  end

  describe port(80) do
    it { is_expected.to be_listening }
  end

  describe port(443) do
    it { is_expected.to be_listening }
  end

  describe command("curl -s --cacert /etc/foreman/certificate.pem https://#{host_inventory['fqdn']} -w '\%{redirect_url}' -o /dev/null") do
    its(:stdout) { is_expected.to eq("https://#{host_inventory['fqdn']}/users/login") }
    its(:exit_status) { is_expected.to eq 0 }
  end
end

shared_examples 'foreman via passenger' do
  include_examples 'foreman application'

  describe package('foreman-service') do
    it { is_expected.not_to be_installed }
  end

  describe service('foreman') do
    it { is_expected.not_to be_enabled }
    it { is_expected.not_to be_running }
  end

  describe port(3000) do
    it { is_expected.not_to be_listening.on('127.0.0.1') }
  end
end

shared_examples 'foreman via puma' do
  include_examples 'foreman application'

  describe package('foreman-service') do
    it { is_expected.to be_installed }
  end

  describe service('foreman') do
    it { is_expected.to be_enabled }
    it { is_expected.to be_running }
  end

  describe port(3000) do
    it { is_expected.to be_listening.on('127.0.0.1').with('tcp') }
  end
end
