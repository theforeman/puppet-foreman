require 'spec_helper_acceptance'

describe 'Scenario: install foreman with rh_cloud', if: os[:family] == 'redhat' do
  before(:context) { purge_foreman }

  it_behaves_like 'an idempotent resource' do
    let(:manifest) do
      <<-PUPPET
      include foreman
      include foreman::plugin::rh_cloud
      PUPPET
    end
  end

  it_behaves_like 'the foreman application'
end
