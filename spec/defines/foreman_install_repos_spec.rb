require 'spec_helper'


describe 'foreman::install::repos' do
  let(:title) { 'foreman' }

  context 'on osfamily debian' do
    let :facts do
      {
        :osfamily        => 'Debian',
      }
    end

    let(:params) { {:repo => 'stable'} }

    it 'should include the apt repo class' do
      should contain_foreman__install__repos__apt('foreman').with_repo('stable')
    end
  end

  context 'on Fedora' do
    let :facts do
      {
        :operatingsystem        => 'Fedora',
        :operatingsystemrelease => '19',
        :osfamily               => 'RedHat',
      }
    end

    let(:params) { {:repo => 'stable'} }

    it 'should include the yum repo class' do
      should contain_foreman__install__repos__yum('foreman').with({
        :repo     => 'stable',
        :yumcode  => 'f19',
        :gpgcheck => true,
      })
    end
  end

  context 'on RedHat' do
    let :facts do
      {
        :operatingsystem        => 'RedHat',
        :operatingsystemrelease => '6.4',
        :osfamily               => 'RedHat',
      }
    end

    let(:params) { {:repo => 'stable'} }

    it 'should include the yum repo class' do
      should contain_foreman__install__repos__yum('foreman').with({
        :repo     => 'stable',
        :yumcode  => 'el6',
        :gpgcheck => true,
      })
    end
  end

  context 'on Amazon' do
    let :facts do
      {
        :operatingsystem        => 'Amazon',
        :operatingsystemrelease => '6.4',
        :osfamily               => 'Linux',
      }
    end

    let(:params) { {:repo => 'stable'} }

    it do
      should contain_foreman__install__repos__yum('foreman').with({
        :repo     => 'stable',
        :yumcode  => 'el6',
        :gpgcheck => true,
      })
    end
  end

  context 'on unsupported Linux operatingsystem' do
    let :facts do
      {
        :hostname        => 'localhost',
        :operatingsystem => 'unsupported',
        :osfamily        => 'Linux',
      }
    end

    let(:params) { {:repo => 'stable'} }

    it 'should fail' do
      should raise_error(/#{facts[:hostname]}: This module does not support operatingsystem #{facts[:operatingsystem]}/)
    end
  end

  context 'on unsupported osfamily' do
    let :facts do
      {
        :hostname => 'localhost',
        :osfamily => 'unsupported',
      }
    end

    let(:params) { {:repo => 'stable'} }

    it 'should fail' do
      should raise_error(/#{facts[:hostname]}: This module does not support osfamily #{facts[:osfamily]}/)
    end
  end
end
