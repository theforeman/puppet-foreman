require 'spec_helper_acceptance'

describe 'Scenario: install foreman with rex cockpit', if: os[:family] == 'redhat' do
  before(:context) { purge_foreman }

  it_behaves_like 'an idempotent resource' do
    let(:manifest) do
      <<-PUPPET
      include foreman
      include foreman::plugin::remote_execution::cockpit
      PUPPET
    end
  end

  it_behaves_like 'the foreman application'

  describe port(19090) do
    it { is_expected.to be_listening.on('127.0.0.1').with('tcp') }
  end

  describe service('foreman-cockpit') do
    it { is_expected.to be_running }
    it { is_expected.to be_enabled }
  end

  describe service('httpd') do
    it { is_expected.to be_running }
    it { is_expected.to be_enabled }
  end

  describe file('/etc/httpd/conf.d/05-foreman-ssl.d/cockpit.conf') do
    it { is_expected.to be_file }
    its(:content) { should match(%r{<Location /webcon>}) }
    its(:content) { should match(%r{ProxyPass http://127\.0\.0\.1:19090/webcon}) }
  end

  describe command('curl -k -s -o /dev/null -w "%{http_code}" https://localhost/webcon/') do
    its(:stdout) { should match(/^(200|302|401)$/) }
  end
end
