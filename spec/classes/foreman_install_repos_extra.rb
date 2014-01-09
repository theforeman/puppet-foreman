require 'spec_helper'

describe 'foreman::install::repos::extra' do
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
      }
    end

    describe 'when fully enabled' do
      it { should contain_yumrepo('epel').with_mirrorlist('https://mirrors.fedoraproject.org/metalink?repo=epel-6&arch=$basearch') }
      it { should_not contain_yumrepo('SCL') }
    end
  end

  context 'CentOS' do
    let :facts do
      {
        :operatingsystem        => 'CentOS',
        :operatingsystemrelease => '6.4',
        :osfamily               => 'RedHat',
      }
    end

    describe 'when fully enabled' do
      it { should contain_yumrepo('epel').with_mirrorlist('https://mirrors.fedoraproject.org/metalink?repo=epel-6&arch=$basearch') }
      it { should contain_yumrepo('SCL').with_baseurl('http://dev.centos.org/centos/6/SCL/$basearch') }
    end
  end

  context 'Scientific Linux' do
    let :facts do
      {
        :operatingsystem        => 'Scientific',
        :operatingsystemrelease => '6.4',
        :osfamily               => 'RedHat',
      }
    end

    describe 'when fully enabled' do
      it { should contain_yumrepo('epel').with_mirrorlist('https://mirrors.fedoraproject.org/metalink?repo=epel-6&arch=$basearch') }
      it { should contain_yumrepo('SCL').with_baseurl('http://ftp.scientificlinux.org/linux/scientific/6/$basearch/external_products/softwarecollections/') }
    end
  end

  context 'Fedora' do
    let :facts do
      {
        :operatingsystem        => 'Fedora',
        :operatingsystemrelease => '19',
        :osfamily               => 'RedHat',
      }
    end

    describe 'when fully enabled' do
      it { should_not contain_yumrepo('epel') }
      it { should_not contain_yumrepo('SCL') }
    end
  end

  context 'on debian' do
    let :facts do
      {
        :operatingsystem        => 'Debian',
        :operatingsystemrelease => 'wheezy',
        :osfamily               => 'Debian',
      }
    end

    describe 'when fully enabled' do
      it { should_not contain_yumrepo('epel') }
      it { should_not contain_yumrepo('SCL') }
    end
  end
end
