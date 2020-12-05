require 'spec_helper_acceptance'

describe 'foreman-cli', order: defined do
  shared_examples 'hammer' do
    describe command('hammer --version') do
      its(:stdout) { is_expected.to match(/^hammer/) }
    end
  end

  context 'without Foreman' do
    before(:context) { purge_foreman }

    context 'without plugins' do
      let(:pp) do
        <<-PUPPET
        class { 'foreman::cli':
          foreman_url => 'https://foreman.example.com',
          username    => 'admin',
          password    => 'changeme',
        }
        PUPPET
      end

      it_behaves_like 'a idempotent resource'

      it_behaves_like 'hammer'
    end

    context 'with plugins' do
      let(:pp) do
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
        PUPPET
      end

      it_behaves_like 'a idempotent resource'

      it_behaves_like 'hammer'

      ['discovery', 'remote_execution', 'tasks', 'templates'].each do |plugin|
        package_name = case fact('os.family')
                       when 'RedHat'
                         fact('os.release.major') == '7' ? "tfm-rubygem-hammer_cli_foreman_#{plugin}" : "rubygem-hammer_cli_foreman_#{plugin}"
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
  end
end
