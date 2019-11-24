shared_examples 'hammer' do
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

  it_behaves_like 'a idempotent resource'

  describe command('hammer --version') do
    its(:stdout) { is_expected.to match(/^hammer/) }
  end
end
