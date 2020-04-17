require 'spec_helper_acceptance'

describe 'Scenario: install foreman-cli + plugins without foreman' do
  before(:context) { purge_foreman }

  let(:pp) do
    <<-PUPPET
    class { 'foreman::cli':
      foreman_url => 'https://foreman.example.com',
      username    => 'admin',
      password    => 'changeme',
    }

    if $facts['osfamily'] == 'RedHat' {
      include foreman::cli::ansible
      include foreman::cli::azure
    }
    include foreman::cli::discovery
    include foreman::cli::remote_execution
    include foreman::cli::tasks
    include foreman::cli::templates
    PUPPET
  end

  it_behaves_like 'a idempotent resource'

  it_behaves_like 'hammer'

  ['discovery', 'remote_execution', 'tasks', 'templates'].each do |plugin|
    package_name = case fact('osfamily')
                   when 'RedHat'
                     fact('operatingsystem') == 'Fedora' ? "rubygem-hammer_cli_foreman_#{plugin}" : "tfm-rubygem-hammer_cli_foreman_#{plugin}"
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
