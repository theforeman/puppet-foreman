require 'spec_helper'

describe 'foreman::cli' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) { facts }

      context 'standalone with parameters' do
        let(:params) do
          {
            foreman_url: 'http://example.com',
            username: 'joe',
            password: 'secret'
          }
        end

        it { is_expected.to compile.with_all_deps }
        it { should contain_package('foreman-cli').with_ensure('installed') }

        describe '/etc/hammer/cli.modules.d/foreman.yml' do
          it 'should contain settings' do
            is_expected.to contain_file('/etc/hammer/cli.modules.d/foreman.yml')
              .with_content(
                <<~CONFIG
                  :foreman:
                    # Enable/disable foreman commands
                    :enable_module: true

                    # Your foreman server address
                    :host: 'http://example.com'

                    # Enable using sessions
                    # When sessions are enabled, hammer ignores credentials stored in the config file
                    # and asks for them interactively at the begining of each session.
                    :use_sessions: false

                    # Check API documentation cache status on each request
                    :refresh_cache: false

                    # API request timeout in seconds, set -1 for infinity
                    :request_timeout: 120

                CONFIG
              )
          end
        end

        describe '/root/.hammer/cli.modules.d/foreman.yml' do
          it 'should contain settings' do
            is_expected.to contain_file('/root/.hammer/cli.modules.d/foreman.yml')
              .with_replace(false)
              .with_content(
                <<~CONFIG
                  :foreman:
                    # Credentials. You'll be asked for the interactively if you leave them blank here
                    :username: 'joe'
                    :password: 'secret'
                CONFIG
              )
          end
        end

        describe 'with manage_root_config=false' do
          let(:params) { super().merge(manage_root_config: false) }
          it { should_not contain_file('/root/.hammer') }
          it { should_not contain_file('/root/.hammer/cli.modules.d/foreman.yml') }
        end

        context 'with ssl_ca_file' do
          let(:params) { super().merge(ssl_ca_file: '/etc/ca.pub') }

          describe '/etc/hammer/cli.modules.d/foreman.yml' do
            it 'should contain settings' do
              is_expected.to contain_file('/etc/hammer/cli.modules.d/foreman.yml')
                .with_content(
                  <<~CONFIG
                    :foreman:
                      # Enable/disable foreman commands
                      :enable_module: true

                      # Your foreman server address
                      :host: 'http://example.com'

                      # Enable using sessions
                      # When sessions are enabled, hammer ignores credentials stored in the config file
                      # and asks for them interactively at the begining of each session.
                      :use_sessions: false

                      # Check API documentation cache status on each request
                      :refresh_cache: false

                      # API request timeout in seconds, set -1 for infinity
                      :request_timeout: 120


                    :ssl:
                      :ssl_ca_file: '/etc/ca.pub'
                  CONFIG
                )
            end
          end
        end
      end

      context 'with repo included' do
        let(:pre_condition) { 'include foreman::repo' }

        it { is_expected.to compile.with_all_deps }
        it { should contain_package('foreman-cli').that_subscribes_to('Anchor[foreman::repo]') }
      end

      context 'with settings from foreman' do
        let :pre_condition do
          <<-PUPPET
          class { 'foreman':
            initial_admin_username => 'jane',
            initial_admin_password => 'supersecret',
            foreman_url            => 'https://foreman.example.com',
            server_ssl_chain       => '/etc/puppetlabs/puppet/ssl/certs/ca.pub',
          }
          PUPPET
        end

        it { is_expected.to compile.with_all_deps }
        it do
          should contain_package('foreman-cli')
            .with_ensure('installed')
        end

        it 'should contain settings in /etc from foreman' do
          is_expected.to contain_file('/etc/hammer/cli.modules.d/foreman.yml')
            .with_content(
              <<~CONFIG
                :foreman:
                  # Enable/disable foreman commands
                  :enable_module: true

                  # Your foreman server address
                  :host: 'https://foreman.example.com'

                  # Enable using sessions
                  # When sessions are enabled, hammer ignores credentials stored in the config file
                  # and asks for them interactively at the begining of each session.
                  :use_sessions: false

                  # Check API documentation cache status on each request
                  :refresh_cache: false

                  # API request timeout in seconds, set -1 for infinity
                  :request_timeout: 120


                :ssl:
                  :ssl_ca_file: '/etc/puppetlabs/puppet/ssl/certs/ca.pub'
              CONFIG
            )
        end

        it 'should contain settings in /root from foreman' do
          is_expected.to contain_file('/root/.hammer/cli.modules.d/foreman.yml')
            .with_content(
              <<~CONFIG
                :foreman:
                  # Credentials. You'll be asked for the interactively if you leave them blank here
                  :username: 'jane'
                  :password: 'supersecret'
              CONFIG
            )
        end
      end
    end
  end
end
