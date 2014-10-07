require 'spec_helper'

describe 'foreman::install::repos::extra' do
  let :pre_condition do
    "class { 'foreman': }"
  end

  let(:params) do
    {
      :configure_scl_repo  => true,
      :configure_epel_repo => true,
    }
  end

  context 'RHEL' do
    let :facts do
      {
        :operatingsystem        => 'RedHat',
        :operatingsystemrelease => '6.4',
        :osfamily               => 'RedHat',
        :rubyversion            => '1.8.7',
        :selinux                => 'true',
        :puppet_vardir          => '/tmp',
        :lsbdistcodename        => 'Santiago',
      }
    end

    describe 'when fully enabled' do
      it { should contain_yumrepo('epel').with({
        :mirrorlist => 'https://mirrors.fedoraproject.org/metalink?repo=epel-6&arch=$basearch',
        :gpgcheck   => 1,
        :gpgkey     => 'https://fedoraproject.org/static/0608B895.txt',
      }) }
      it { should_not contain_package('centos-release-SCL') }
      it { should_not contain_yumrepo('SCL') }
    end
  end

  context 'RHEL 7' do
    let :facts do
      {
        :operatingsystem        => 'RedHat',
        :operatingsystemrelease => '7.0',
        :osfamily               => 'RedHat',
        :selinux                => 'true',
        :puppet_vardir          => '/tmp',
        :lsbdistcodename        => 'Santiago',
      }
    end

    describe 'when fully enabled' do
      it { should contain_yumrepo('epel').with({
        :mirrorlist => 'https://mirrors.fedoraproject.org/metalink?repo=epel-7&arch=$basearch',
        :gpgcheck   => 1,
        :gpgkey     => 'https://fedoraproject.org/static/352C64E5.txt',
      }) }
      it { should_not contain_package('centos-release-SCL') }
      it { should_not contain_yumrepo('SCL') }
    end
  end

  context 'CentOS' do
    let :facts do
      {
        :operatingsystem        => 'CentOS',
        :operatingsystemrelease => '6.4',
        :osfamily               => 'RedHat',
        :rubyversion            => '1.8.7',
        :selinux                => 'true',
        :puppet_vardir          => '/tmp',
        :lsbdistcodename        => 'Santiago',
      }
    end

    describe 'when fully enabled' do
      it { should contain_yumrepo('epel').with_mirrorlist('https://mirrors.fedoraproject.org/metalink?repo=epel-6&arch=$basearch') }
      it { should contain_package('centos-release-SCL') }
      it { should_not contain_yumrepo('SCL') }
    end
  end

  context 'Scientific Linux' do
    let :facts do
      {
        :operatingsystem        => 'Scientific',
        :operatingsystemrelease => '6.4',
        :osfamily               => 'RedHat',
        :rubyversion            => '1.8.7',
        :selinux                => 'true',
        :puppet_vardir          => '/tmp',
        :lsbdistcodename        => 'Santiago',
      }
    end

    describe 'when fully enabled' do
      it { should contain_yumrepo('epel').with_mirrorlist('https://mirrors.fedoraproject.org/metalink?repo=epel-6&arch=$basearch') }
      it { should_not contain_package('centos-release-SCL') }
      it { should contain_yumrepo('SCL').with_baseurl('http://ftp.scientificlinux.org/linux/scientific/6/$basearch/external_products/softwarecollections/') }
    end
  end

  context 'Fedora' do
    let :facts do
      {
        :operatingsystem        => 'Fedora',
        :operatingsystemrelease => '19',
        :osfamily               => 'RedHat',
        :selinux                => 'true',
        :puppet_vardir          => '/tmp',
        :lsbdistcodename        => 'Santiago',
      }
    end

    describe 'when fully enabled' do
      it { should_not contain_yumrepo('epel') }
      it { should_not contain_package('centos-release-SCL') }
      it { should_not contain_yumrepo('SCL') }
    end
  end

  context 'on debian' do
    let :facts do
      {
        :operatingsystem        => 'Debian',
        :operatingsystemrelease => 'wheezy',
        :osfamily               => 'Debian',
        :lsbdistcodename        => 'wheezy',
        :selinux                => 'false',
        :puppet_vardir          => '/tmp',
      }
    end

    describe 'when fully enabled' do
      it { should_not contain_yumrepo('epel') }
      it { should_not contain_package('centos-release-SCL') }
      it { should_not contain_yumrepo('SCL') }
    end
  end
end
