require 'spec_helper_acceptance'

describe 'foreman', order: :defined do
  shared_examples 'the foreman application' do
    [
      ['debian', 'ubuntu'].include?(os[:family]) ? 'apache2' : 'httpd',
      'dynflow-sidekiq@orchestrator',
      'dynflow-sidekiq@worker',
      'foreman',
    ].each do |service_name|
      describe service(service_name) do
        it { is_expected.to be_enabled }
        it { is_expected.to be_running }
      end
    end

    describe port(80) do
      it { is_expected.to be_listening }
    end

    describe port(443) do
      it { is_expected.to be_listening }
    end

    describe file('/run/foreman.sock') do
      it { should be_socket }
    end

    describe command("curl -s --cacert /etc/foreman-certs/certificate.pem https://#{host_inventory['fqdn']} -w '\%{redirect_url}' -o /dev/null") do
      its(:stdout) { is_expected.to eq("https://#{host_inventory['fqdn']}/users/login") }
      its(:exit_status) { is_expected.to eq 0 }
    end
  end

  before(:context) { purge_foreman }

  context 'without plugins' do
    let(:pp) do
      <<-PUPPET
      include foreman
      PUPPET
    end

    it_behaves_like 'a idempotent resource'
    it_behaves_like 'the foreman application'

    describe package('foreman-journald') do
      it { is_expected.not_to be_installed }
    end

    describe package('foreman-telemetry') do
      it { is_expected.not_to be_installed }
    end
  end

  context 'with journald' do
    let(:pp) do
      <<-PUPPET
      class { 'foreman':
        logging_type => 'journald',
      }
      PUPPET
    end

    it_behaves_like 'a idempotent resource'
    it_behaves_like 'the foreman application'

    describe package('foreman-journald') do
      it { is_expected.to be_installed }
    end

    # Logging to the journal is broken on Docker 18+ and EL7 but works in Vagrant
    # VMs (and EL7's Docker version)
    broken_journald_logging = ENV['BEAKER_HYPERVISOR'] == 'docker' && os[:family] == 'redhat' && os[:release] =~ /^7\./

    describe command('journalctl -u foreman'), unless: broken_journald_logging do
      its(:stdout) { is_expected.to match(%r{Redirected to https://#{host_inventory['fqdn']}/users/login}) }
    end

    describe command('journalctl -u dynflow-sidekiq@orchestrator'), unless: broken_journald_logging do
      its(:stdout) { is_expected.to match(%r{Everything ready for world: }) }
    end
  end

  context 'with prometheus' do
    let(:pp) do
      <<-PUPPET
      class { 'foreman':
        telemetry_prometheus_enabled => true,
      }
      PUPPET
    end

    it_behaves_like 'a idempotent resource'
    it_behaves_like 'the foreman application'

    describe package('foreman-telemetry') do
      it { is_expected.to be_installed }
    end

    # TODO: actually verify prometheus functionality
  end

  context 'with statsd' do
    let(:pp) do
      <<-PUPPET
      class { 'foreman':
        telemetry_statsd_enabled => true,
      }
      PUPPET
    end

    it_behaves_like 'a idempotent resource'
    it_behaves_like 'the foreman application'

    describe package('foreman-telemetry') do
      it { is_expected.to be_installed }
    end

    # TODO: actually verify statsd functionality
  end

  context 'with rex cockpit', if: os[:family] == 'centos' do
    let(:pp) do
      <<-PUPPET
      include foreman
      include foreman::plugin::remote_execution::cockpit
      PUPPET
    end

    it_behaves_like 'a idempotent resource'
    it_behaves_like 'the foreman application'

    describe port(19090) do
      it { is_expected.to be_listening.on('127.0.0.1').with('tcp') }
    end
  end
end
