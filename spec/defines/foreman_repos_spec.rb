require 'spec_helper'

describe 'foreman::repos' do
  let(:title) { 'foreman' }
  let(:repo) { '1.18' }
  let(:params) { { repo: repo, yum_repo_baseurl: 'http://example.org' } }

  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) { facts }

      case facts[:osfamily]
      when 'RedHat'
        yumcode = case os
                  when /^fedora-/
                    "f#{facts[:operatingsystemmajrelease]}"
                  else
                    "el#{facts[:operatingsystemmajrelease]}"
                  end

        it do
          is_expected.to contain_foreman__repos__yum('foreman')
            .with_repo(repo)
            .with_yumcode(yumcode)
            .with_gpgcheck(true)
            .with_baseurl('http://example.org')
        end
      when 'Debian'
        it { is_expected.to contain_foreman__repos__apt('foreman').with_repo(repo) }
      end
    end
  end

  # TODO: on_supported_os?
  context 'on Amazon' do
    let :facts do
      {
        os: {
          family: 'Linux',
          name: 'Amazon',
        },
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
        networking: {
          hostname: 'localhost',
        },
        os: {
          family: 'unsupported',
        },
      }
    end

    it 'should fail' do
      is_expected.to compile.and_raise_error(/#{facts[:hostname]}: This module does not support osfamily #{facts[:osfamily]}/)
    end
  end
end
