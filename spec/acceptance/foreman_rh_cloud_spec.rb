require 'spec_helper_acceptance'

describe 'Scenario: install foreman with rh_cloud', if: os[:family] == 'redhat' do
  before(:context) { purge_foreman }

  it_behaves_like 'an idempotent resource' do
    let(:manifest) do
      <<-PUPPET
      yumrepo { 'katello':
        baseurl  => "http://yum.theforeman.org/katello/nightly/katello/el${facts['os']['release']['major']}/x86_64/",
        gpgcheck => 0,
      }
      yumrepo { 'candlepin':
        baseurl  => "https://yum.theforeman.org/candlepin/4.4/el${facts['os']['release']['major']}/x86_64/",
        gpgcheck => 0,
      }

      include foreman
      include foreman::plugin::rh_cloud
      PUPPET
    end
  end

  it_behaves_like 'the foreman application'
end
