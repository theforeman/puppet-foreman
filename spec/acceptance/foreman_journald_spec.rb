require 'spec_helper_acceptance'

describe 'Scenario: install foreman with journald' do
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
      user_groups            => [],
      initial_admin_username => 'admin',
      initial_admin_password => 'changeme',
      server_ssl_ca          => $certificate,
      server_ssl_chain       => $certificate,
      server_ssl_cert        => $certificate,
      server_ssl_key         => $key,
      server_ssl_crl         => '',
      logging_type           => 'journald',
    }
    EOS
  end

  it_behaves_like 'a idempotent resource'

  it_behaves_like 'the foreman application'

  describe package('foreman-journald') do
    it { is_expected.to be_installed }
  end

  # Logging to the journal is broken on Travis and EL7 but works in Vagrant VMs
  # and regular docker containers
  describe command('journalctl -u foreman'), unless: ENV['TRAVIS'] == 'true' && os[:family] == 'redhat' && os[:release] =~ /^7\./ do
    its(:stdout) { is_expected.to match(%r{Redirected to https://#{host_inventory['fqdn']}/users/login}) }
  end

  describe command('journalctl -u dynflow-sidekiq@orchestrator'), unless: ENV['TRAVIS'] == 'true' && os[:family] == 'redhat' && os[:release] =~ /^7\./ do
    its(:stdout) { is_expected.to match(%r{Everything ready for world: }) }
  end
end
