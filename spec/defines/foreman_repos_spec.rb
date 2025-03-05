require 'spec_helper'

describe 'foreman::repos' do
  let(:title) { 'foreman' }
  let(:repo) { '1.18' }
  let(:params) { { repo: repo, yum_repo_baseurl: 'http://example.org' } }

  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) { facts }

      case facts[:os]['family']
      when 'RedHat'
        yumcode = case os
                  when /^fedora-/
                    "f#{facts[:os]['release']['major']}"
                  else
                    "el#{facts[:os]['release']['major']}"
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
      is_expected.to compile.and_raise_error(/#{facts[:networking]['hostname']}: This module does not support osfamily #{facts[:os]['family']}/)
    end
  end
end
