require 'spec_helper_acceptance'

shared_examples 'global-parameter' do |name, type, v|
  describe command("hammer global-parameter list --search name=#{name} --fields type") do
    its(:stdout) { is_expected.to include(type.to_s) }
  end
  describe command("hammer global-parameter list --search name=#{name} --fields value") do
    its(:stdout) { is_expected.to include(v.to_s) }
  end
end

describe 'Scenario: install foreman and manage some global parameters', order: :defined do
  before(:context) { purge_foreman }

  it_behaves_like 'an idempotent resource' do
    let(:manifest) do
      <<-PUPPET
      include foreman
      include foreman::cli

      Foreman_global_parameter {
        ensure          => present,
        base_url        => $foreman::foreman_url,
        consumer_key    => $foreman::oauth_consumer_key,
        consumer_secret => $foreman::oauth_consumer_secret,
        ssl_ca          => $foreman::server_ssl_ca,
        timeout         => 5,
      }

      foreman_global_parameter { 'boolean-true-test':
        parameter_type => 'boolean',
        value          => true,
      }

      foreman_global_parameter { 'boolean-false-test':
        parameter_type => 'boolean',
        value          => false,
      }

      PUPPET
    end
  end

  it_behaves_like 'the foreman application'
  it_behaves_like 'hammer'

  it_behaves_like 'global-parameter', 'boolean-true-test', 'boolean', true
  it_behaves_like 'global-parameter', 'boolean-false-test', 'boolean', false

  describe 'removing a hostgroup' do
    it_behaves_like 'an idempotent resource' do
      let(:manifest) do
        <<-PUPPET
        include foreman

        Foreman_global_parameter {
          ensure          => present,
          base_url        => $foreman::foreman_url,
          consumer_key    => $foreman::oauth_consumer_key,
          consumer_secret => $foreman::oauth_consumer_secret,
          ssl_ca          => $foreman::server_ssl_ca,
          timeout         => 5,
        }

        foreman_global_parameter { 'boolean-true-test':
          ensure => absent,
        }
        PUPPET
      end
    end

    describe command('hammer global-parameter list --search name=boolean-true-test') do
      its(:stdout) { is_expected.not_to include('boolean-true-test') }
    end
  end
end
