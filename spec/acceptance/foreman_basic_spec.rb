require 'spec_helper_acceptance'

describe 'Scenario: install foreman' do
  before(:context) do
    case fact('osfamily')
    when 'RedHat'
      on default, 'yum -y remove foreman* tfm-* && rm -rf /etc/yum.repos.d/foreman*.repo'
    when 'Debian'
      on default, 'apt-get purge -y foreman*', { :acceptable_exit_codes => [0, 100] }
      on default, 'apt-get purge -y ruby-hammer-cli-*', { :acceptable_exit_codes => [0, 100] }
      on default, 'rm -rf /etc/apt/sources.list.d/foreman*'
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

    # Get a certificate from puppet
    exec { 'puppet_server_config-generate_ca_cert':
      creates => '/etc/puppetlabs/puppet/ssl/certs/#{host_inventory['fqdn']}.pem',
      command => '/opt/puppetlabs/bin/puppet ca generate #{host_inventory['fqdn']}',
      umask   => '0022',
    }

    # Actual test
    class { '::foreman':
      repo                => 'nightly',
      user_groups         => [],
      admin_username      => 'admin',
      admin_password      => 'changeme',
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

  describe package('foreman-journald') do
    it { is_expected.not_to be_installed }
  end

  describe package('foreman-telemetry') do
    it { is_expected.not_to be_installed }
  end

  describe port(80) do
    it { is_expected.to be_listening }
  end

  describe port(443) do
    it { is_expected.to be_listening }
  end
end
