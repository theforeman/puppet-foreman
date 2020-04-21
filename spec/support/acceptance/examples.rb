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

  describe port(3000) do
    it { is_expected.to be_listening.on('127.0.0.1').with('tcp') }
  end

  describe command("curl -s --cacert /etc/foreman-certs/certificate.pem https://#{host_inventory['fqdn']} -w '\%{redirect_url}' -o /dev/null") do
    its(:stdout) { is_expected.to eq("https://#{host_inventory['fqdn']}/users/login") }
    its(:exit_status) { is_expected.to eq 0 }
  end
end

shared_examples 'hammer' do
  describe command('hammer --version') do
    its(:stdout) { is_expected.to match(/^hammer/) }
  end
end
