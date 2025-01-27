require 'spec_helper_acceptance'

describe 'Scenario: install foreman with rh_cloud', if: os[:family] == 'redhat' do
  before(:context) { purge_foreman }

  it_behaves_like 'an idempotent resource' do
    let(:manifest) do
      <<-PUPPET
      # iop_advisor_engine requires foreman-proxy certs to talk back to Foreman
      # TODO: redesign the deployment in a way that it better aligns with our architecture
      file { '/etc/foreman-proxy':
        ensure => directory,
      }

      group { 'foreman-proxy':
        ensure => present,
      }

      include foreman
      include foreman::plugin::rh_cloud
      PUPPET
    end
  end

  it_behaves_like 'the foreman application'
end
