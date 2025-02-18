require 'spec_helper_acceptance'

describe 'Scenario: install foreman-cli + plugins without foreman' do
  before(:context) { purge_foreman }

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
          include foreman::cli::azure
          include foreman::cli::kubevirt
          include foreman::cli::openscap
          include foreman::cli::resource_quota
        }
        include foreman::cli::ansible
        include foreman::cli::bootdisk
        include foreman::cli::discovery
        include foreman::cli::google
        include foreman::cli::puppet
        include foreman::cli::remote_execution
        include foreman::cli::ssh
        include foreman::cli::tasks
        include foreman::cli::templates
        include foreman::cli::webhooks
        PUPPET
      end
    end

    it_behaves_like 'hammer'

    ['ansible', 'bootdisk', 'discovery', 'google', 'puppet', 'remote_execution', 'ssh', 'tasks', 'templates', 'webhooks'].each do |plugin|
      package_name = case fact('os.family')
                     when 'RedHat'
                       "rubygem-hammer_cli_foreman_#{plugin}"
                     when 'Debian'
                       "ruby-hammer-cli-foreman-#{plugin.tr('_', '-')}"
                     else
                       plugin
                     end

      describe package(package_name) do
        it { is_expected.to be_installed }
      end
    end

    if fact('os.family') == 'RedHat'
      ['azure_rm', 'kubevirt', 'openscap', 'resource_quota'].each do |plugin|
        describe package("rubygem-hammer_cli_foreman_#{plugin}") do
          it { is_expected.to be_installed }
        end
      end
    end
  end

  if fact('os.family') == 'RedHat'
    context 'for katello' do
      it_behaves_like 'an idempotent resource' do
        let(:manifest) do
          <<-PUPPET
          class { 'foreman::cli':
            foreman_url => 'https://foreman.example.com',
            username    => 'admin',
            password    => 'changeme',
          }

          include foreman::cli::katello
          include foreman::cli::virt_who_configure
          include foreman::cli::rh_cloud
          PUPPET
        end
      end

      it_behaves_like 'hammer'

      ['katello', 'foreman_virt_who_configure', 'foreman_rh_cloud'].each do |plugin|
        describe package("rubygem-hammer_cli_#{plugin}") do
          it { is_expected.to be_installed }
        end
      end
    end
  end
end
