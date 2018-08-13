require 'spec_helper'

describe 'foreman::repos' do
  let(:title) { 'foreman' }
  let(:repo) { '1.18' }
  let(:params) { { repo: repo } }

  on_os_under_test.each do |os, facts|
    context "on #{os}" do
      let :facts do
        facts
      end

      case facts[:osfamily]
      when 'RedHat'
        case os
        when /^fedora-/
          yumcode = "f#{facts[:operatingsystemmajrelease]}"
        else
          yumcode = "el#{facts[:operatingsystemmajrelease]}"
        end

        it do
          is_expected.to contain_foreman__repos__yum('foreman')
            .with_repo(repo)
            .with_yumcode(yumcode)
            .with_gpgcheck(true)
        end
      when 'Debian'
        it { is_expected.to contain_foreman__repos__apt('foreman').with_repo(repo) }
      end
    end
  end

  # TODO: on_os_under_test?
  context 'on Amazon' do
    let :facts do
      {
        :operatingsystem => 'Amazon',
        :osfamily        => 'Linux',
      }
    end

    it do
      is_expected.to contain_foreman__repos__yum('foreman')
        .with_repo(repo)
        .with_yumcode('el7')
        .with_gpgcheck(true)
    end
  end

  context 'on unsupported osfamily' do
    let :facts do
      {
        :hostname => 'localhost',
        :osfamily => 'unsupported',
      }
    end

    it 'should fail' do
      is_expected.to raise_error(/#{facts[:hostname]}: This module does not support osfamily #{facts[:osfamily]}/)
    end
  end
end
