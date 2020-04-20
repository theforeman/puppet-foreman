require 'spec_helper_acceptance'

describe 'Scenario: install foreman-cli without foreman' do
  before(:context) do
    case fact('osfamily')
    when 'RedHat'
      on default, 'yum -y remove foreman* tfm-* && rm -rf /etc/yum.repos.d/foreman*.repo'
    when 'Debian'
      on default, 'apt-get purge -y foreman*', { :acceptable_exit_codes => [0, 100] }
      on default, 'apt-get purge -y ruby-hammer-cli-*', { :acceptable_exit_codes => [0, 100] }
      on default, 'rm -rf /etc/apt/sources.list.d/foreman*'
    end
  end

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
    EOS
  end

  it_behaves_like 'a idempotent resource'

  it_behaves_like 'hammer'
end
