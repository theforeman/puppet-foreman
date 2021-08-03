require 'spec_helper_acceptance'

describe 'Scenario: install foreman-cli + plugins without foreman' do
  before(:context) { purge_foreman }

  package_prefix = fact('os.release.major') == '7' ? "tfm-" : ""

  context 'for standard plugins' do

    it_behaves_like 'an idempotent resource' do
      let(:manifest) do
        <<-PUPPET
        class { 'foreman::cli':
          foreman_url => 'https://foreman.example.com',
          username    => 'admin',
          password    => 'changeme',
        }

        if $facts['os']['family'] == 'RedHat' {
          include foreman::cli::ansible
          include foreman::cli::azure
        }
        include foreman::cli::discovery
        include foreman::cli::remote_execution
        include foreman::cli::tasks
        include foreman::cli::templates
        include foreman::cli::webhooks
        include foreman::cli::puppet
        PUPPET
      end
    end

    it_behaves_like 'hammer'

    ['discovery', 'remote_execution', 'tasks', 'templates', 'webhooks', 'puppet'].each do |plugin|
      package_name = case fact('os.family')
                     when 'RedHat'
                       "#{package_prefix}rubygem-hammer_cli_foreman_#{plugin}"
                     when 'Debian'
                       "ruby-hammer-cli-foreman-#{plugin.tr('_', '-')}"
                     else
                       plugin
                     end

      describe package(package_name) do
        it { is_expected.to be_installed }
      end
    end
  end

  if fact('os.family') == 'RedHat'
    context 'for katello' do
      it_behaves_like 'an idempotent resource' do
        let(:manifest) do
          <<-PUPPET
          yumrepo { 'katello':
            baseurl  => "http://yum.theforeman.org/katello/nightly/katello/el${facts['os']['release']['major']}/x86_64/",
            gpgcheck => 0,
          }

          class { 'foreman::cli':
            foreman_url => 'https://foreman.example.com',
            username    => 'admin',
            password    => 'changeme',
          }

          include foreman::cli::katello

          Yumrepo['katello'] -> Class['foreman::cli::katello']
          PUPPET
        end
      end

      it_behaves_like 'hammer'

      package_name = "#{package_prefix}rubygem-hammer_cli_katello"
      describe package(package_name) do
        it { is_expected.to be_installed }
      end
    end
  end
end
