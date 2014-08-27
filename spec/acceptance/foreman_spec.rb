require 'spec_helper_acceptance'

describe 'foreman class' do
  case fact('osfamily')
  when 'RedHat'
    service_name = 'httpd'
  when 'Debian'
    service_name = 'apache2'
  end

  context 'default parameters' do
    # Using puppet_apply as a helper
    it 'should work with no errors' do
      pp = <<-EOS
      exec {"/usr/bin/puppet cert generate ${::fqdn}":
        creates => '/var/lib/puppet/ssl/certs/ca.pem',
      } ->
      class { 'foreman': }
      EOS

      # Run it twice and test for idempotency
      apply_manifest(pp, :catch_failures => true)
      # Breaks in docker because it can't enable the services
      #expect(apply_manifest(pp, :catch_failures => true).exit_code).to be_zero
    end

    describe package('foreman-postgresql') do
      it { should be_installed }
    end

    describe service(service_name) do
      it { should be_enabled }
      it { should be_running }
    end

    it 'should show the login form' do
      shell("/usr/bin/curl -s -L --cacert /var/lib/puppet/ssl/certs/ca.pem https://#{fact('fqdn')}", {:acceptable_exit_codes => 0}) do |r|
        r.stdout.should match(/login-form/)
      end
    end
  end
end
