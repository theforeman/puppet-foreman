require 'spec_helper'

describe 'foreman::install::repos::extra' do
  describe 'when EL repos are fully enabled' do
    let(:params) do
      {
        :configure_scl_repo  => true,
        :configure_epel_repo => true,
      }
    end

    context 'RHEL 6' do
      let :facts do
        {
          :operatingsystem        => 'RedHat',
          :operatingsystemrelease => '6.4',
          :osfamily               => 'RedHat',
        }
      end

      it { should contain_yumrepo('epel').with({
        :mirrorlist => 'https://mirrors.fedoraproject.org/metalink?repo=epel-6&arch=$basearch',
        :gpgcheck   => 1,
        :gpgkey     => 'https://fedoraproject.org/static/0608B895.txt',
      }) }
      it { should contain_package('foreman-release-scl') }
    end

    context 'RHEL 7' do
      let :facts do
        {
          :operatingsystem        => 'RedHat',
          :operatingsystemrelease => '7.0',
          :osfamily               => 'RedHat',
        }
      end

      it { should contain_yumrepo('epel').with({
        :mirrorlist => 'https://mirrors.fedoraproject.org/metalink?repo=epel-7&arch=$basearch',
        :gpgcheck   => 1,
        :gpgkey     => 'https://fedoraproject.org/static/352C64E5.txt',
      }) }
      it { should contain_package('foreman-release-scl') }
    end
  end

  describe 'when deb repos are fully enabled' do
    let(:params) do
      {
        :configure_brightbox_repo  => true,
      }
    end

    context 'Ubuntu' do
      let :facts do
        {
          :lsbdistid              => 'ubuntu',
          :lsbdistcodename        => 'precise',
          :operatingsystem        => 'Ubuntu',
          :operatingsystemrelease => '12.04',
          :osfamily               => 'Debian',
        }
      end

      it { should contain_class('apt') }
      it { should contain_apt__ppa('ppa:brightbox/ruby-ng') }
    end
  end

  describe 'when fully disabled' do
    let(:params) do
      {
        :configure_scl_repo       => false,
        :configure_epel_repo      => false,
        :configure_brightbox_repo => false,
      }
    end

    context 'RHEL 6' do
      let :facts do
        {
          :operatingsystem        => 'RedHat',
          :operatingsystemrelease => '6.4',
          :osfamily               => 'RedHat',
        }
      end

      it { should_not contain_yumrepo('epel') }
      it { should_not contain_package('foreman-release-scl') }
      it { should_not contain_class('apt') }
      it { should have_apt__ppa_resource_count(0) }
    end
  end
end
