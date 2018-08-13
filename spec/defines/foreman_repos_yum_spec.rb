require 'spec_helper'

describe 'foreman::repos::yum' do
  let(:title) { 'foreman' }

  context 'with repo => nightly' do
    context 'gpgcheck => true' do
      let(:params) { {:repo => 'nightly', :yumcode => 'el7', :gpgcheck => true} }

      it 'should contain repo, plugins and source repo' do
        should contain_yumrepo('foreman').with(
          :descr    => 'Foreman nightly',
          :baseurl  => 'https://yum.theforeman.org/releases/nightly/el7/$basearch',
          :gpgcheck => '0',
          :gpgkey   => 'https://yum.theforeman.org/releases/nightly/RPM-GPG-KEY-foreman',
          :enabled  => '1',
        )

        should contain_yumrepo('foreman-source').with(
          :descr    => 'Foreman nightly - source',
          :baseurl  => 'https://yum.theforeman.org/releases/nightly/el7/source',
          :gpgcheck => '0',
          :gpgkey   => 'https://yum.theforeman.org/releases/nightly/RPM-GPG-KEY-foreman',
          :enabled  => '0',
        )

        should contain_yumrepo('foreman-plugins').with(
          :descr    => 'Foreman plugins nightly',
          :baseurl  => 'https://yum.theforeman.org/plugins/nightly/el7/$basearch',
          :gpgcheck => '0',
          :enabled  => '1',
        )

        should contain_yumrepo('foreman-plugins-source').with(
          :descr    => 'Foreman plugins nightly - source',
          :baseurl  => 'https://yum.theforeman.org/plugins/nightly/el7/source',
          :gpgcheck => '0',
          :enabled  => '0',
        )

        should contain_yumrepo('foreman-rails').with(
          :descr    => 'Rails SCL for Foreman nightly',
          :baseurl  => 'https://yum.theforeman.org/rails/foreman-nightly/el7/$basearch',
          :gpgcheck => '0',
          :enabled  => '1',
          :gpgkey   => 'https://yum.theforeman.org/rails/foreman-nightly/RPM-GPG-KEY-copr',
        )
      end
    end

    context 'gpgcheck => false' do
      let(:params) { {:repo => 'nightly', :yumcode => 'el7', :gpgcheck => false} }

      it 'should contain repo, plugins and source repo' do
        should contain_yumrepo('foreman').with(
          :descr    => 'Foreman nightly',
          :baseurl  => 'https://yum.theforeman.org/releases/nightly/el7/$basearch',
          :gpgcheck => '0',
          :gpgkey   => 'https://yum.theforeman.org/releases/nightly/RPM-GPG-KEY-foreman',
          :enabled  => '1',
        )

        should contain_yumrepo('foreman-source').with(
          :descr    => 'Foreman nightly - source',
          :baseurl  => 'https://yum.theforeman.org/releases/nightly/el7/source',
          :gpgcheck => '0',
          :gpgkey   => 'https://yum.theforeman.org/releases/nightly/RPM-GPG-KEY-foreman',
          :enabled  => '0',
        )

        should contain_yumrepo('foreman-plugins').with(
          :descr    => 'Foreman plugins nightly',
          :baseurl  => 'https://yum.theforeman.org/plugins/nightly/el7/$basearch',
          :gpgcheck => '0',
          :enabled  => '1',
        )

        should contain_yumrepo('foreman-plugins-source').with(
          :descr    => 'Foreman plugins nightly - source',
          :baseurl  => 'https://yum.theforeman.org/plugins/nightly/el7/source',
          :gpgcheck => '0',
          :enabled  => '0',
        )

        should contain_yumrepo('foreman-rails').with(
          :descr    => 'Rails SCL for Foreman nightly',
          :baseurl  => 'https://yum.theforeman.org/rails/foreman-nightly/el7/$basearch',
          :gpgcheck => '0',
          :enabled  => '1',
          :gpgkey   => 'https://yum.theforeman.org/rails/foreman-nightly/RPM-GPG-KEY-copr',
        )
      end
    end
  end

  context 'with repo => 1.19' do
    context 'gpgcheck => true' do
      let(:params) { {:repo => '1.19', :yumcode => 'el7', :gpgcheck => true} }

      it 'should contain repo, plugins and source repo' do
        should contain_yumrepo('foreman').with(
          :descr    => 'Foreman 1.19',
          :baseurl  => 'https://yum.theforeman.org/releases/1.19/el7/$basearch',
          :gpgcheck => '1',
          :gpgkey   => 'https://yum.theforeman.org/releases/1.19/RPM-GPG-KEY-foreman',
          :enabled  => '1',
        )

        should contain_yumrepo('foreman-source').with(
          :descr    => 'Foreman 1.19 - source',
          :baseurl  => 'https://yum.theforeman.org/releases/1.19/el7/source',
          :gpgcheck => '1',
          :gpgkey   => 'https://yum.theforeman.org/releases/1.19/RPM-GPG-KEY-foreman',
          :enabled  => '0',
        )

        should contain_yumrepo('foreman-plugins').with(
          :descr    => 'Foreman plugins 1.19',
          :baseurl  => 'https://yum.theforeman.org/plugins/1.19/el7/$basearch',
          :gpgcheck => '0',
          :enabled  => '1',
        )

        should contain_yumrepo('foreman-plugins-source').with(
          :descr    => 'Foreman plugins 1.19 - source',
          :baseurl  => 'https://yum.theforeman.org/plugins/1.19/el7/source',
          :gpgcheck => '0',
          :enabled  => '0',
        )

        should contain_yumrepo('foreman-rails').with(
          :descr    => 'Rails SCL for Foreman 1.19',
          :baseurl  => 'https://yum.theforeman.org/rails/foreman-1.19/el7/$basearch',
          :gpgcheck => '1',
          :enabled  => '1',
          :gpgkey   => 'https://yum.theforeman.org/rails/foreman-1.19/RPM-GPG-KEY-copr',
        )
      end
    end

    context 'gpgcheck => false' do
      let(:params) { {:repo => '1.19', :yumcode => 'el7', :gpgcheck => false} }

      it 'should contain repo, plugins and source repo' do
        should contain_yumrepo('foreman').with(
          :descr    => 'Foreman 1.19',
          :baseurl  => 'https://yum.theforeman.org/releases/1.19/el7/$basearch',
          :gpgcheck => '0',
          :gpgkey   => 'https://yum.theforeman.org/releases/1.19/RPM-GPG-KEY-foreman',
          :enabled  => '1',
        )

        should contain_yumrepo('foreman-source').with(
          :descr    => 'Foreman 1.19 - source',
          :baseurl  => 'https://yum.theforeman.org/releases/1.19/el7/source',
          :gpgcheck => '0',
          :gpgkey   => 'https://yum.theforeman.org/releases/1.19/RPM-GPG-KEY-foreman',
          :enabled  => '0',
        )

        should contain_yumrepo('foreman-plugins').with(
          :descr    => 'Foreman plugins 1.19',
          :baseurl  => 'https://yum.theforeman.org/plugins/1.19/el7/$basearch',
          :gpgcheck => '0',
          :enabled  => '1',
        )

        should contain_yumrepo('foreman-plugins-source').with(
          :descr    => 'Foreman plugins 1.19 - source',
          :baseurl  => 'https://yum.theforeman.org/plugins/1.19/el7/source',
          :gpgcheck => '0',
          :enabled  => '0',
        )

        should contain_yumrepo('foreman-rails').with(
          :descr    => 'Rails SCL for Foreman 1.19',
          :baseurl  => 'https://yum.theforeman.org/rails/foreman-1.19/el7/$basearch',
          :gpgcheck => '0',
          :enabled  => '1',
          :gpgkey   => 'https://yum.theforeman.org/rails/foreman-1.19/RPM-GPG-KEY-copr',
        )
      end
    end
  end
end
