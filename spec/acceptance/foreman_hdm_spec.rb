require 'spec_helper_acceptance'

describe 'Scenario: install foreman with hdm' do
  before(:context) { purge_foreman }

  it_behaves_like 'an idempotent resource' do
    let(:manifest) do
      <<-PUPPET
      include foreman
      include foreman::plugin::hdm
      PUPPET
    end
  end

  it_behaves_like 'the foreman application'
  describe curl_command("https://#{host_inventory['fqdn']}/api/plugins", cacert: '/etc/foreman-certs/certificate.pem', user: 'admin:changeme') do
    its(:stdout) { should include('foreman_hdm') }
    its(:exit_status) { should eq 0 }
  end
end
