require 'spec_helper'


describe 'foreman::install::repos::yum' do
  let(:title) { 'foreman' }

  context 'with repo => stable' do
    context 'with gpgcheck => true' do
      let(:params) { {:repo => 'stable', :yumcode => 'el6', :gpgcheck => true} }

      it 'should contain repo, plugins and source repo' do
        should contain_yumrepo('foreman').with({
          :descr    => 'Foreman stable repository',
          :baseurl  => 'http://yum.theforeman.org/releases/latest/el6/$basearch',
          :gpgcheck => '1',
          :gpgkey   => 'http://yum.theforeman.org/releases/latest/RPM-GPG-KEY-foreman',
          :enabled  => '1',
        })

        should contain_yumrepo('foreman-plugins').with({
          :descr    => 'Foreman stable plugins repository',
          :baseurl  => 'http://yum.theforeman.org/plugins/latest/el6/$basearch',
          :gpgcheck => '0',
          :enabled  => '1',
        })

        should contain_yumrepo('foreman-source').with({
          :descr    => 'Foreman stable source repository',
          :baseurl  => 'http://yum.theforeman.org/releases/latest/el6/source',
          :gpgcheck => '1',
          :gpgkey   => 'http://yum.theforeman.org/releases/latest/RPM-GPG-KEY-foreman',
          :enabled  => '0',
        })

      end
    end

    context 'with gpgcheck => false' do
      let(:params) { {:repo => 'stable', :yumcode => 'el6', :gpgcheck => false} }

      it 'should contain repo, plugins and source repo' do
        should contain_yumrepo('foreman').with({
          :descr    => 'Foreman stable repository',
          :baseurl  => 'http://yum.theforeman.org/releases/latest/el6/$basearch',
          :gpgcheck => '0',
          :gpgkey   => 'http://yum.theforeman.org/releases/latest/RPM-GPG-KEY-foreman',
          :enabled  => '1',
        })

        should contain_yumrepo('foreman-plugins').with({
          :descr    => 'Foreman stable plugins repository',
          :baseurl  => 'http://yum.theforeman.org/plugins/latest/el6/$basearch',
          :gpgcheck => '0',
          :enabled  => '1',
        })

        should contain_yumrepo('foreman-source').with({
          :descr    => 'Foreman stable source repository',
          :baseurl  => 'http://yum.theforeman.org/releases/latest/el6/source',
          :gpgcheck => '0',
          :gpgkey   => 'http://yum.theforeman.org/releases/latest/RPM-GPG-KEY-foreman',
          :enabled  => '0',
        })
      end
    end
  end

  context 'with repo => nightly' do
    context 'gpgcheck => true' do
      let(:params) { {:repo => 'nightly', :yumcode => 'el6', :gpgcheck => true} }

      it 'should contain repo, plugins and source repo' do
        should contain_yumrepo('foreman').with({
          :descr    => 'Foreman nightly repository',
          :baseurl  => 'http://yum.theforeman.org/nightly/el6/$basearch',
          :gpgcheck => '0',
          :gpgkey   => 'http://yum.theforeman.org/nightly/RPM-GPG-KEY-foreman',
          :enabled  => '1',
        })

        should contain_yumrepo('foreman-plugins').with({
          :descr    => 'Foreman nightly plugins repository',
          :baseurl  => 'http://yum.theforeman.org/plugins/nightly/el6/$basearch',
          :gpgcheck => '0',
          :enabled  => '1',
        })

        should contain_yumrepo('foreman-source').with({
          :descr    => 'Foreman nightly source repository',
          :baseurl  => 'http://yum.theforeman.org/nightly/el6/source',
          :gpgcheck => '0',
          :gpgkey   => 'http://yum.theforeman.org/nightly/RPM-GPG-KEY-foreman',
          :enabled  => '0',
        })
      end
    end

    context 'gpgcheck => false' do
      let(:params) { {:repo => 'nightly', :yumcode => 'el6', :gpgcheck => false} }

      it 'should contain repo, plugins and source repo' do
        should contain_yumrepo('foreman').with({
          :descr    => 'Foreman nightly repository',
          :baseurl  => 'http://yum.theforeman.org/nightly/el6/$basearch',
          :gpgcheck => '0',
          :gpgkey   => 'http://yum.theforeman.org/nightly/RPM-GPG-KEY-foreman',
          :enabled  => '1',
        })

        should contain_yumrepo('foreman-plugins').with({
          :descr    => 'Foreman nightly plugins repository',
          :baseurl  => 'http://yum.theforeman.org/plugins/nightly/el6/$basearch',
          :gpgcheck => '0',
          :enabled  => '1',
        })

        should contain_yumrepo('foreman-source').with({
          :descr    => 'Foreman nightly source repository',
          :baseurl  => 'http://yum.theforeman.org/nightly/el6/source',
          :gpgcheck => '0',
          :gpgkey   => 'http://yum.theforeman.org/nightly/RPM-GPG-KEY-foreman',
          :enabled  => '0',
        })
      end
    end
  end

  context 'with repo => 1.7' do
    context 'gpgcheck => true' do
      let(:params) { {:repo => '1.7', :yumcode => 'el6', :gpgcheck => true} }

      it 'should contain repo, plugins and source repo' do
        should contain_yumrepo('foreman').with({
          :descr    => 'Foreman 1.7 repository',
          :baseurl  => 'http://yum.theforeman.org/releases/1.7/el6/$basearch',
          :gpgcheck => '1',
          :gpgkey   => 'http://yum.theforeman.org/releases/1.7/RPM-GPG-KEY-foreman',
          :enabled  => '1',
        })

        should contain_yumrepo('foreman-plugins').with({
          :descr    => 'Foreman 1.7 plugins repository',
          :baseurl  => 'http://yum.theforeman.org/plugins/1.7/el6/$basearch',
          :gpgcheck => '0',
          :enabled  => '1',
        })

        should contain_yumrepo('foreman-source').with({
          :descr    => 'Foreman 1.7 source repository',
          :baseurl  => 'http://yum.theforeman.org/releases/1.7/el6/source',
          :gpgcheck => '1',
          :gpgkey   => 'http://yum.theforeman.org/releases/1.7/RPM-GPG-KEY-foreman',
          :enabled  => '0',
        })
      end
    end

    context 'gpgcheck => false' do
      let(:params) { {:repo => '1.7', :yumcode => 'el6', :gpgcheck => false} }

      it 'should contain repo, plugins and source repo' do
        should contain_yumrepo('foreman').with({
          :descr    => 'Foreman 1.7 repository',
          :baseurl  => 'http://yum.theforeman.org/releases/1.7/el6/$basearch',
          :gpgcheck => '0',
          :gpgkey   => 'http://yum.theforeman.org/releases/1.7/RPM-GPG-KEY-foreman',
          :enabled  => '1',
        })

        should contain_yumrepo('foreman-plugins').with({
          :descr    => 'Foreman 1.7 plugins repository',
          :baseurl  => 'http://yum.theforeman.org/plugins/1.7/el6/$basearch',
          :gpgcheck => '0',
          :enabled  => '1',
        })

        should contain_yumrepo('foreman-source').with({
          :descr    => 'Foreman 1.7 source repository',
          :baseurl  => 'http://yum.theforeman.org/releases/1.7/el6/source',
          :gpgcheck => '0',
          :gpgkey   => 'http://yum.theforeman.org/releases/1.7/RPM-GPG-KEY-foreman',
          :enabled  => '0',
        })
      end
    end
  end
end
