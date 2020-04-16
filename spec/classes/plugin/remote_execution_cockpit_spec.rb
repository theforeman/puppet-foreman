require 'spec_helper'

describe 'foreman::plugin::remote_execution::cockpit' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) { facts }
      let(:pre_condition) do
        <<-PUPPET
        class {'foreman':
          foreman_url      => 'https://foreman.example.com',
          server_ssl_chain => '/path/to/ca.pem',
          client_ssl_cert  => '/path/to/cert.pem',
          client_ssl_key   => '/path/to/key.pem',
        }
        PUPPET
      end

      it { is_expected.to compile.with_all_deps }
      it { is_expected.to contain_foreman__plugin('remote_execution-cockpit').that_notifies("Class[foreman::service]") }
      it 'contains dependencies' do
        is_expected.to contain_foreman__plugin('remote_execution')
        is_expected.to contain_foreman__plugin('tasks')
      end

      it { is_expected.to contain_service('foreman-cockpit').with_ensure('running').with_enable('true') }

      it 'creates configs' do
        is_expected.to contain_file('/etc/foreman/cockpit/cockpit.conf')
          .with_ensure('file')
          .with_content([
            '[WebService]',
            'LoginTitle = Foreman Cockpit',
            'UrlRoot = /webcon/',
            'Origins = https://foreman.example.com',
            '',
            '[Bearer]',
            'Action = remote-login-ssh',
            '',
            '[SSH-Login]',
            'command = /usr/sbin/foreman-cockpit-session',
            '',
            '[OAuth]',
            'Url = /cockpit/redirect',
          ].join("\n") + "\n")
          .that_requires('Foreman::Plugin[remote_execution-cockpit]')
          .that_notifies('Service[foreman-cockpit]')

        is_expected.to contain_file('/etc/foreman/cockpit/foreman-cockpit-session.yml')
          .with_ensure('file')
          .with_content([
            '---',
            ':foreman_url: "https://foreman.example.com"',
            ':ssl_ca_file: "/path/to/ca.pem"',
            ':ssl_certificate: "/path/to/cert.pem"',
            ':ssl_private_key: "/path/to/key.pem"',
          ].join("\n") + "\n")
          .that_requires('Foreman::Plugin[remote_execution-cockpit]')
          .that_notifies('Service[foreman-cockpit]')
      end

      it 'configures apache' do
        is_expected.to contain_class('apache::mod::proxy_wstunnel')
        is_expected.to contain_class('apache::mod::proxy_http')
        is_expected.to contain_foreman__config__apache__fragment('cockpit')
          .without_content
          .with_ssl_content(%r{^<Location /webcon>$})
          .with_ssl_content(%r{^  RewriteRule /webcon/\(\.\*\)           ws://127\.0\.0\.1:19090/webcon/\$1 \[P\]$})
          .with_ssl_content(%r{^  RewriteRule /webcon/\(\.\*\)           http://127\.0\.0\.1:19090/webcon/\$1 \[P\]$})
      end
    end
  end
end
