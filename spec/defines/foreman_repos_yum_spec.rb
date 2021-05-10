require 'spec_helper'

describe 'foreman::repos::yum' do
  let(:title) { 'foreman' }
  let(:params) { { yumcode: 'el7', baseurl: 'https://yum.theforeman.org' } }

  context 'with repo => nightly' do
    let(:params) { super().merge(repo: 'nightly') }

    context 'gpgcheck => true' do
      let(:params) { super().merge(gpgcheck: true) }

      context 'baseurl => custom' do
        let(:params) { super().merge(baseurl: 'http://example.org') }

        it 'should contain repo, plugins and source repo' do
          should contain_yumrepo('foreman')
            .with_descr('Foreman nightly')
            .with_baseurl('http://example.org/releases/nightly/el7/$basearch')
            .with_gpgcheck('0')
            .with_gpgkey('http://example.org/releases/nightly/RPM-GPG-KEY-foreman')
            .with_enabled('1')
            .with_priority('absent')

          should contain_yumrepo('foreman-source')
            .with_descr('Foreman nightly - source')
            .with_baseurl('http://example.org/releases/nightly/el7/source')
            .with_gpgcheck('0')
            .with_gpgkey('http://example.org/releases/nightly/RPM-GPG-KEY-foreman')
            .with_enabled('0')
            .with_priority('absent')

          should contain_yumrepo('foreman-plugins')
            .with_descr('Foreman plugins nightly')
            .with_baseurl('http://example.org/plugins/nightly/el7/$basearch')
            .with_gpgcheck('0')
            .with_enabled('1')
            .with_priority('absent')

          should contain_yumrepo('foreman-plugins-source')
            .with_descr('Foreman plugins nightly - source')
            .with_baseurl('http://example.org/plugins/nightly/el7/source')
            .with_gpgcheck('0')
            .with_enabled('0')
            .with_priority('absent')

          should contain_yumrepo('foreman-rails').with_ensure('absent')
        end

        context 'keypath => custom' do
          let(:params) { super().merge(keypath: 'http://examplekeys.org/GPG-KEY') }

          it 'should contain repo and source with custom GPG key path and same baseurl' do
            should contain_yumrepo('foreman')
              .with_baseurl('http://example.org/releases/nightly/el7/$basearch')
              .with_gpgkey('http://examplekeys.org/GPG-KEY')

            should contain_yumrepo('foreman-source')
              .with_baseurl('http://example.org/releases/nightly/el7/source')
              .with_gpgkey('http://examplekeys.org/GPG-KEY')
          end
        end
      end

      context 'priority => 10' do
        let(:params) { super().merge(priority: 10) }
        it 'should contain repo, plugins and source with correct priority' do
          should contain_yumrepo('foreman')
            .with_priority(10)

          should contain_yumrepo('foreman-source')
            .with_priority(10)

          should contain_yumrepo('foreman-plugins')
            .with_priority(10)

          should contain_yumrepo('foreman-plugins-source')
            .with_priority(10)
        end
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
          .with_priority('absent')

        should contain_yumrepo('foreman-source')
          .with_descr('Foreman nightly - source')
          .with_baseurl('https://yum.theforeman.org/releases/nightly/el7/source')
          .with_gpgcheck('0')
          .with_gpgkey('https://yum.theforeman.org/releases/nightly/RPM-GPG-KEY-foreman')
          .with_enabled('0')
          .with_priority('absent')

        should contain_yumrepo('foreman-plugins')
          .with_descr('Foreman plugins nightly')
          .with_baseurl('https://yum.theforeman.org/plugins/nightly/el7/$basearch')
          .with_gpgcheck('0')
          .with_enabled('1')
          .with_priority('absent')

        should contain_yumrepo('foreman-plugins-source')
          .with_descr('Foreman plugins nightly - source')
          .with_baseurl('https://yum.theforeman.org/plugins/nightly/el7/source')
          .with_gpgcheck('0')
          .with_enabled('0')
          .with_priority('absent')

        should contain_yumrepo('foreman-rails').with_ensure('absent')
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
          .with_priority('absent')

        should contain_yumrepo('foreman-source')
          .with_descr('Foreman 1.19 - source')
          .with_baseurl('https://yum.theforeman.org/releases/1.19/el7/source')
          .with_gpgcheck('1')
          .with_gpgkey('https://yum.theforeman.org/releases/1.19/RPM-GPG-KEY-foreman')
          .with_enabled('0')
          .with_priority('absent')

        should contain_yumrepo('foreman-plugins')
          .with_descr('Foreman plugins 1.19')
          .with_baseurl('https://yum.theforeman.org/plugins/1.19/el7/$basearch')
          .with_gpgcheck('0')
          .with_enabled('1')
          .with_priority('absent')

        should contain_yumrepo('foreman-plugins-source')
          .with_descr('Foreman plugins 1.19 - source')
          .with_baseurl('https://yum.theforeman.org/plugins/1.19/el7/source')
          .with_gpgcheck('0')
          .with_enabled('0')
          .with_priority('absent')

        should contain_yumrepo('foreman-rails').with_ensure('absent')
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
          .with_priority('absent')

        should contain_yumrepo('foreman-source')
          .with_descr('Foreman 1.19 - source')
          .with_baseurl('https://yum.theforeman.org/releases/1.19/el7/source')
          .with_gpgcheck('0')
          .with_gpgkey('https://yum.theforeman.org/releases/1.19/RPM-GPG-KEY-foreman')
          .with_enabled('0')
          .with_priority('absent')

        should contain_yumrepo('foreman-plugins')
          .with_descr('Foreman plugins 1.19')
          .with_baseurl('https://yum.theforeman.org/plugins/1.19/el7/$basearch')
          .with_gpgcheck('0')
          .with_enabled('1')
          .with_priority('absent')

        should contain_yumrepo('foreman-plugins-source')
          .with_descr('Foreman plugins 1.19 - source')
          .with_baseurl('https://yum.theforeman.org/plugins/1.19/el7/source')
          .with_gpgcheck('0')
          .with_enabled('0')
          .with_priority('absent')

        should contain_yumrepo('foreman-rails').with_ensure('absent')
      end
    end
  end
end
