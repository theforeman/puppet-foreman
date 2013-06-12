require 'spec_helper'


describe 'foreman::install::repos' do
  let(:title) { 'foreman' }

  context 'on debian' do
    let :facts do
      {
        :lsbdistcodename => 'squeeze',
        :operatingsystem => 'Debian',
        :osfamily        => 'Debian',
      }
    end

    context 'with repo => stable' do
      let(:params) { {:repo => 'stable'} }

      it do
        should contain_file('/etc/apt/sources.list.d/foreman.list') \
          .with_content("deb http://deb.theforeman.org/ squeeze stable\n")
      end
    end

    context 'with repo => rc' do
      let(:params) { {:repo => 'rc'} }

      it do
        should contain_file('/etc/apt/sources.list.d/foreman.list') \
          .with_content("deb http://deb.theforeman.org/ squeeze rc\n")
      end
    end

    context 'with repo => nightly' do
      let(:params) { {:repo => 'nightly'} }

      it do
        should contain_file('/etc/apt/sources.list.d/foreman.list') \
          .with_content("deb http://deb.theforeman.org/ squeeze nightly\n")
      end
    end
  end

  context 'on fedora' do
    let :facts do
      {
        :operatingsystem        => 'Fedora',
        :osfamily               => 'RedHat',
        :operatingsystemrelease => '17',
      }
    end

    context 'with repo => stable' do
      let(:params) { {:repo => 'stable'} }

      it do
        should contain_yumrepo('foreman') \
          .with_baseurl('http://yum.theforeman.org/releases/latest/f17/$basearch')
      end
    end

    context 'with repo => rc' do
      let(:params) { {:repo => 'rc'} }

      it do
        should contain_yumrepo('foreman') \
          .with_baseurl('http://yum.theforeman.org/rc/f17/$basearch')
      end
    end

    context 'with repo => nightly' do
      let(:params) { {:repo => 'nightly'} }

      it do
        should contain_yumrepo('foreman') \
          .with_baseurl('http://yum.theforeman.org/nightly/f17/$basearch')
      end
    end
  end

  context 'on EL' do
    let :facts do
      {
        :operatingsystem => 'RedHat',
        :osfamily => 'RedHat',
        :operatingsystemrelease => '6.3'
      }
    end

    context 'with repo => stable' do
      let(:params) { {:repo => 'stable'} }

      it do
        should contain_yumrepo('foreman') \
          .with_baseurl('http://yum.theforeman.org/releases/latest/el6/$basearch')
      end
    end

    context 'with repo => rc' do
      let(:params) { {:repo => 'rc'} }

      it do
        should contain_yumrepo('foreman') \
          .with_baseurl('http://yum.theforeman.org/rc/el6/$basearch')
      end
    end

    context 'with repo => nightly' do
      let(:params) { {:repo => 'nightly'} }

      it do
        should contain_yumrepo('foreman') \
          .with_baseurl('http://yum.theforeman.org/nightly/el6/$basearch')
      end
    end
  end
end
