require 'spec_helper_acceptance'

describe 'Scenario: install foreman and manage some hostgroups', order: :defined do
  before(:context) { purge_foreman }

  it_behaves_like 'an idempotent resource' do
    let(:manifest) do
      <<-PUPPET
      include foreman

      Foreman_hostgroup {
        ensure          => present,
        base_url        => $foreman::foreman_url,
        consumer_key    => $foreman::oauth_consumer_key,
        consumer_secret => $foreman::oauth_consumer_secret,
        ssl_ca          => $foreman::server_ssl_ca,
        timeout         => 5,
      }

      foreman_hostgroup { 'example_hostgroup':
        description => 'An example parent hostgroup',
      }

      foreman_hostgroup { 'example_hostgroup/child':
        description => 'An example child hostgroup',
      }

      include foreman::cli
      PUPPET
    end
  end

  it_behaves_like 'the foreman application'
  it_behaves_like 'hammer'

  describe command('hammer hostgroup list') do
    its(:stdout) { is_expected.to include('example_hostgroup/child') }
  end

  describe 'removing a hostgroup' do
    it_behaves_like 'an idempotent resource' do
      let(:manifest) do
        <<-PUPPET
        include foreman

        Foreman_hostgroup {
          ensure          => present,
          base_url        => $foreman::foreman_url,
          consumer_key    => $foreman::oauth_consumer_key,
          consumer_secret => $foreman::oauth_consumer_secret,
          ssl_ca          => $foreman::server_ssl_ca,
          timeout         => 5,
        }

        foreman_hostgroup { 'example_hostgroup/child':
          ensure => absent,
        }
        PUPPET
      end
    end

    describe command('hammer hostgroup list') do
      its(:stdout) { is_expected.not_to include('example_hostgroup/child') }
    end
  end
end
