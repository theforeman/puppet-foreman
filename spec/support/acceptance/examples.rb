shared_examples 'the foreman application' do |params = {}|
  [
    ['debian', 'ubuntu'].include?(os[:family]) ? 'apache2' : 'httpd',
    'dynflow-sidekiq@orchestrator',
    'dynflow-sidekiq@worker-1',
    'foreman',
  ].each do |service_name|
    describe service(service_name) do
      it { is_expected.to be_enabled }
      it { is_expected.to be_running }
    end
    describe command("journalctl --boot --catalog --no-pager --unit #{service_name}") do
      its(:stdout) { should match /#{service_name}/ }
      its(:exit_status) { should eq 0 }
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
    its(:stdout) { is_expected.to eq("https://#{host_inventory['fqdn']}#{params.fetch(:expected_login_url_path, '/users/login')}") }
    its(:exit_status) { is_expected.to eq 0 }
  end
end

shared_examples 'hammer' do
  describe command('hammer --version') do
    its(:stdout) { is_expected.to match(/^hammer/) }
  end
end
