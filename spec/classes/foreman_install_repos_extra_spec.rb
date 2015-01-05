require 'spec_helper'

describe 'foreman::install::repos::extra' do

  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts.merge({
          :concat_basedir => '/tmp',
        })
      end

      describe 'when repos are fully enabled' do
        case facts[:osfamily]
        when 'Debian'
          if facts[:operatingsystem] == 'Ubuntu'
            let(:params) do
              {
                :configure_brightbox_repo => true,
              }
            end

            it { should contain_class('apt') }
            it { should contain_apt__ppa('ppa:brightbox/ruby-ng') }
            it { should contain_alternatives('ruby') }
            it { should contain_alternatives('gem') }
          end
        when 'RedHat'
          if facts[:operatingsystem] != 'Fedora'
            let(:params) do
              {
                :configure_scl_repo  => true,
                :configure_epel_repo => true,
              }
            end

            let(:gpgkey) do
              case facts[:operatingsystemmajrelease]
              when '6'
                '0608B895'
              when '7'
                '352C64E5'
              end
            end

            it { should contain_yumrepo('epel').with({
              :mirrorlist => "https://mirrors.fedoraproject.org/metalink?repo=epel-#{facts[:operatingsystemmajrelease]}&arch=$basearch",
              :gpgcheck   => 1,
              :gpgkey     => "https://fedoraproject.org/static/#{gpgkey}.txt",
            }) }
            it { should contain_package('foreman-release-scl') }
          end
        end
      end

      describe 'when fully disabled' do
        let(:params) do
          {
            :configure_scl_repo       => false,
            :configure_epel_repo      => false,
            :configure_brightbox_repo => false,
          }
        end

        it { should_not contain_yumrepo('epel') }
        it { should_not contain_package('foreman-release-scl') }
        it { should_not contain_class('apt') }
        it { should have_apt__ppa_resource_count(0) }
      end
    end
  end
end
