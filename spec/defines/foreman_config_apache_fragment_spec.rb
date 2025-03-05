require 'spec_helper'

describe 'foreman::config::apache::fragment' do
  let(:title) { 'test' }

  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) { facts }

      confd_dir = case facts[:os]['family']
                  when 'RedHat'
                    '/etc/httpd/conf.d'
                  when 'Debian'
                    '/etc/apache2/conf.d'
                  end

      context 'with ssl turned off' do
        let :pre_condition do
          <<~PUPPET
          class { 'foreman::config::apache':
            ssl => false,
          }
          PUPPET
        end

        context 'with default parameters' do
          it { should contain_file("#{confd_dir}/05-foreman.d/test.conf").with_ensure(:absent) }
          it { should contain_file("#{confd_dir}/05-foreman-ssl.d/test.conf").with_ensure(:absent) }
        end

        context 'with content parameter' do
          let :params do
            { content: '# config' }
          end

          it { should contain_file("#{confd_dir}/05-foreman.d/test.conf").with_content('# config') }
          it { should contain_file("#{confd_dir}/05-foreman-ssl.d/test.conf").with_ensure(:absent) }
        end

        context 'with ssl_content parameter' do
          let :params do
            { ssl_content: '# config' }
          end

          it { should contain_file("#{confd_dir}/05-foreman.d/test.conf").with_ensure(:absent) }
          it { should contain_file("#{confd_dir}/05-foreman-ssl.d/test.conf").with_ensure(:absent) }
        end
      end

      context 'with ssl turned on' do
        let :pre_condition do
          <<~PUPPET
          class { 'foreman::config::apache':
            ssl => true,
          }
          PUPPET
        end

        context 'with ssl_content parameter' do
          let :params do
            { :ssl_content => '# config' }
          end

          it { should contain_file("#{confd_dir}/05-foreman.d/test.conf").with_ensure(:absent) }
          it { should contain_file("#{confd_dir}/05-foreman-ssl.d/test.conf").with_content('# config') }
        end
      end
    end
  end
end
