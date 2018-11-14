require 'spec_helper'

describe 'foreman::repos::yum' do
  let(:title) { 'foreman' }
  let(:params) { { yumcode: 'el7' } }

  context 'with repo => nightly' do
    let(:params) { super().merge(repo: 'nightly') }

    context 'gpgcheck => true' do
      let(:params) { super().merge(gpgcheck: true) }

      it 'should contain repo, plugins and source repo' do
        should contain_yumrepo('foreman')
          .with_descr('Foreman nightly')
          .with_baseurl('https://yum.theforeman.org/releases/nightly/el7/$basearch')
          .with_gpgcheck('0')
          .with_gpgkey('https://yum.theforeman.org/releases/nightly/RPM-GPG-KEY-foreman')
          .with_enabled('1')

        should contain_yumrepo('foreman-source')
          .with_descr('Foreman nightly - source')
          .with_baseurl('https://yum.theforeman.org/releases/nightly/el7/source')
          .with_gpgcheck('0')
          .with_gpgkey('https://yum.theforeman.org/releases/nightly/RPM-GPG-KEY-foreman')
          .with_enabled('0')

        should contain_yumrepo('foreman-plugins')
          .with_descr('Foreman plugins nightly')
          .with_baseurl('https://yum.theforeman.org/plugins/nightly/el7/$basearch')
          .with_gpgcheck('0')
          .with_enabled('1')

        should contain_yumrepo('foreman-plugins-source')
          .with_descr('Foreman plugins nightly - source')
          .with_baseurl('https://yum.theforeman.org/plugins/nightly/el7/source')
          .with_gpgcheck('0')
          .with_enabled('0')

        should contain_yumrepo('foreman-rails')
          .with_descr('Rails SCL for Foreman nightly')
          .with_baseurl('https://yum.theforeman.org/rails/foreman-nightly/el7/$basearch')
          .with_gpgcheck('0')
          .with_enabled('1')
          .with_gpgkey('https://yum.theforeman.org/rails/foreman-nightly/RPM-GPG-KEY-copr')
      end
    end

    context 'gpgcheck => false' do
      let(:params) { super().merge(gpgcheck: false) }

      it 'should contain repo, plugins and source repo' do
        should contain_yumrepo('foreman')
          .with_descr('Foreman nightly')
          .with_baseurl('https://yum.theforeman.org/releases/nightly/el7/$basearch')
          .with_gpgcheck('0')
          .with_gpgkey('https://yum.theforeman.org/releases/nightly/RPM-GPG-KEY-foreman')
          .with_enabled('1')

        should contain_yumrepo('foreman-source')
          .with_descr('Foreman nightly - source')
          .with_baseurl('https://yum.theforeman.org/releases/nightly/el7/source')
          .with_gpgcheck('0')
          .with_gpgkey('https://yum.theforeman.org/releases/nightly/RPM-GPG-KEY-foreman')
          .with_enabled('0')

        should contain_yumrepo('foreman-plugins')
          .with_descr('Foreman plugins nightly')
          .with_baseurl('https://yum.theforeman.org/plugins/nightly/el7/$basearch')
          .with_gpgcheck('0')
          .with_enabled('1')

        should contain_yumrepo('foreman-plugins-source')
          .with_descr('Foreman plugins nightly - source')
          .with_baseurl('https://yum.theforeman.org/plugins/nightly/el7/source')
          .with_gpgcheck('0')
          .with_enabled('0')

        should contain_yumrepo('foreman-rails')
          .with_descr('Rails SCL for Foreman nightly')
          .with_baseurl('https://yum.theforeman.org/rails/foreman-nightly/el7/$basearch')
          .with_gpgcheck('0')
          .with_enabled('1')
          .with_gpgkey('https://yum.theforeman.org/rails/foreman-nightly/RPM-GPG-KEY-copr')
      end
    end
  end

  context 'with repo => 1.19' do
    let(:params) { super().merge(repo: '1.19') }

    context 'gpgcheck => true' do
      let(:params) { super().merge(gpgcheck: true) }

      it 'should contain repo, plugins and source repo' do
        should contain_yumrepo('foreman')
          .with_descr('Foreman 1.19')
          .with_baseurl('https://yum.theforeman.org/releases/1.19/el7/$basearch')
          .with_gpgcheck('1')
          .with_gpgkey('https://yum.theforeman.org/releases/1.19/RPM-GPG-KEY-foreman')
          .with_enabled('1')

        should contain_yumrepo('foreman-source')
          .with_descr('Foreman 1.19 - source')
          .with_baseurl('https://yum.theforeman.org/releases/1.19/el7/source')
          .with_gpgcheck('1')
          .with_gpgkey('https://yum.theforeman.org/releases/1.19/RPM-GPG-KEY-foreman')
          .with_enabled('0')

        should contain_yumrepo('foreman-plugins')
          .with_descr('Foreman plugins 1.19')
          .with_baseurl('https://yum.theforeman.org/plugins/1.19/el7/$basearch')
          .with_gpgcheck('0')
          .with_enabled('1')

        should contain_yumrepo('foreman-plugins-source')
          .with_descr('Foreman plugins 1.19 - source')
          .with_baseurl('https://yum.theforeman.org/plugins/1.19/el7/source')
          .with_gpgcheck('0')
          .with_enabled('0')

        should contain_yumrepo('foreman-rails')
          .with_descr('Rails SCL for Foreman 1.19')
          .with_baseurl('https://yum.theforeman.org/rails/foreman-1.19/el7/$basearch')
          .with_gpgcheck('1')
          .with_enabled('1')
          .with_gpgkey('https://yum.theforeman.org/rails/foreman-1.19/RPM-GPG-KEY-copr')
      end
    end

    context 'gpgcheck => false' do
      let(:params) { super().merge(gpgcheck: false) }

      it 'should contain repo, plugins and source repo' do
        should contain_yumrepo('foreman')
          .with_descr('Foreman 1.19')
          .with_baseurl('https://yum.theforeman.org/releases/1.19/el7/$basearch')
          .with_gpgcheck('0')
          .with_gpgkey('https://yum.theforeman.org/releases/1.19/RPM-GPG-KEY-foreman')
          .with_enabled('1')

        should contain_yumrepo('foreman-source')
          .with_descr('Foreman 1.19 - source')
          .with_baseurl('https://yum.theforeman.org/releases/1.19/el7/source')
          .with_gpgcheck('0')
          .with_gpgkey('https://yum.theforeman.org/releases/1.19/RPM-GPG-KEY-foreman')
          .with_enabled('0')

        should contain_yumrepo('foreman-plugins')
          .with_descr('Foreman plugins 1.19')
          .with_baseurl('https://yum.theforeman.org/plugins/1.19/el7/$basearch')
          .with_gpgcheck('0')
          .with_enabled('1')

        should contain_yumrepo('foreman-plugins-source')
          .with_descr('Foreman plugins 1.19 - source')
          .with_baseurl('https://yum.theforeman.org/plugins/1.19/el7/source')
          .with_gpgcheck('0')
          .with_enabled('0')

        should contain_yumrepo('foreman-rails')
          .with_descr('Rails SCL for Foreman 1.19')
          .with_baseurl('https://yum.theforeman.org/rails/foreman-1.19/el7/$basearch')
          .with_gpgcheck('0')
          .with_enabled('1')
          .with_gpgkey('https://yum.theforeman.org/rails/foreman-1.19/RPM-GPG-KEY-copr')
      end
    end
  end
end
