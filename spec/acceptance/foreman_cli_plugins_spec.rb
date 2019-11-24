require 'spec_helper_acceptance'

describe 'Scenario: install foreman-cli + plugins without foreman' do
  let(:pp) do
    configure = fact('osfamily') == 'RedHat' && fact('operatingsystem') != 'Fedora'
    <<-EOS
    class { '::foreman::repo':
      repo                => 'nightly',
      gpgcheck            => true,
      configure_epel_repo => #{configure},
      configure_scl_repo  => #{configure},
    } ->
    class { '::foreman::cli':
      foreman_url => 'https://foreman.example.com',
      username    => 'admin',
      password    => 'changeme',
    }

    if $facts['osfamily'] == 'RedHat' {
      include ::foreman::cli::ansible
      include ::foreman::cli::azure
    }
    include ::foreman::cli::discovery
    include ::foreman::cli::remote_execution
    include ::foreman::cli::tasks
    include ::foreman::cli::templates
    EOS
  end

  include_examples 'hammer'

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
