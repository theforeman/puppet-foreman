require 'spec_helper'

describe 'foreman::plugin::openscap' do
  on_supported_os.each do |os, facts|
    if facts[:osfamily] == 'RedHat'
      context "on #{os}" do
        let :facts do
          facts
        end

        repo_base = facts[:operatingsystem] == 'Fedora' ? 'fedora' : 'epel'
        context 'with configure_openscap_repo set to true' do
          let :params do
            {
              :configure_openscap_repo => true
            }
          end

          it 'should call the plugin' do
            should contain_foreman__plugin('openscap')
          end

          it 'should install custom openscap repo' do
            should contain_yumrepo("isimluk-openscap").
                     with_baseurl("http://copr-be.cloud.fedoraproject.org/results/isimluk/OpenSCAP/#{repo_base}-#{facts[:operatingsystemmajrelease]}-$basearch/")
          end
        end

        context 'with disabled repository installation' do
          let :params do
            {
              :configure_openscap_repo => false
            }
          end

          it 'should call the plugin' do
            should contain_foreman__plugin('openscap')
          end

          it 'should not install custom openscap repo' do
            should_not contain_yumrepo("isimluk-openscap")
          end
        end
      end
    end
  end
end
