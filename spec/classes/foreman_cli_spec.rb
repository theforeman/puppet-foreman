require 'spec_helper'

describe 'foreman::cli' do
  on_os_under_test.each do |os, facts|
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
            verify_exact_contents(catalogue, '/etc/hammer/cli.modules.d/foreman.yml', [
                                    ':foreman:',
                                    '  :enable_module: true',
                                    "  :host: 'http://example.com'"
                                  ])
          end
        end

        describe '/root/.hammer/cli.modules.d/foreman.yml' do
          it { should contain_file('/root/.hammer/cli.modules.d/foreman.yml').with_replace(false) }

          it 'should contain settings' do
            verify_exact_contents(catalogue, '/root/.hammer/cli.modules.d/foreman.yml', [
                                    ':foreman:',
                                    "  :username: 'joe'",
                                    "  :password: 'secret'",
                                    '  :refresh_cache: false',
                                    '  :request_timeout: 120'
                                  ])
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
              verify_exact_contents(catalogue, '/etc/hammer/cli.modules.d/foreman.yml', [
                                      ':foreman:',
                                      '  :enable_module: true',
                                      "  :host: 'http://example.com'",
                                      ':ssl:',
                                      "  :ssl_ca_file: '/etc/ca.pub'"
                                    ])
            end
          end
        end
      end

      context 'with settings from foreman' do
        let :pre_condition do
          <<-PUPPET
          class { 'foreman':
            admin_username   => 'jane',
            admin_password   => 'supersecret',
            foreman_url      => 'https://foreman.example.com',
            server_ssl_chain => '/etc/puppetlabs/puppet/ssl/certs/ca.pub',
          }
          PUPPET
        end

        it { is_expected.to compile.with_all_deps }
        it do
          should contain_package('foreman-cli')
            .with_ensure('installed')
            .that_subscribes_to('Class[foreman::repo]')
        end

        it 'should contain settings in /etc from foreman' do
          verify_exact_contents(catalogue, '/etc/hammer/cli.modules.d/foreman.yml', [
                                  ':foreman:',
                                  '  :enable_module: true',
                                  "  :host: 'https://foreman.example.com'",
                                  ':ssl:',
                                  "  :ssl_ca_file: '/etc/puppetlabs/puppet/ssl/certs/ca.pub'"
                                ])
        end

        it 'should contain settings in /root from foreman' do
          verify_exact_contents(catalogue, '/root/.hammer/cli.modules.d/foreman.yml', [
                                  ':foreman:',
                                  "  :username: 'jane'",
                                  "  :password: 'supersecret'",
                                  '  :refresh_cache: false',
                                  '  :request_timeout: 120'
                                ])
        end
      end
    end
  end
end
