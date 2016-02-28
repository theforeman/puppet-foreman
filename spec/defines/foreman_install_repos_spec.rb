require 'spec_helper'

describe 'foreman::install::repos' do
  let(:title) { 'foreman' }

  on_supported_os.each do |os, facts|
    next if only_test_os() and not only_test_os.include?(os)
    next if exclude_test_os() and exclude_test_os.include?(os)

    context "on #{os}" do
      let :facts do
        facts
      end

      describe 'on stable' do
        let(:params) { {:repo => 'stable'} }

        case facts[:osfamily]
        when 'RedHat'
          case os
          when 'fedora-19-x86_64'
            yumcode = 'f19'
          else
            yumcode = "el#{facts[:operatingsystemmajrelease]}"
          end

          it { should contain_foreman__install__repos__yum('foreman').with({
            :repo     => 'stable',
            :yumcode  => yumcode,
            :gpgcheck => true,
          }) }
        when 'Debian'
          it { should contain_foreman__install__repos__apt('foreman').with_repo('stable') }
        end
      end
    end
  end

  # TODO: on_supported_os?
  context 'on Amazon' do
    let :facts do
      {
        :operatingsystem        => 'Amazon',
        :operatingsystemrelease => '6.4',
        :osfamily               => 'Linux',
        :rubyversion            => '1.8.7',
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
