require 'spec_helper'

describe 'foreman::config::passenger::fragment' do
  let(:title) { 'test' }

  let :pre_condition do
    'include foreman'
  end

  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let :facts do
        facts.merge(:concat_basedir => '/tmp')
      end

      confd_dir = case facts[:osfamily]
                  when 'RedHat'
                    '/etc/httpd/conf.d'
                  when 'Debian'
                    '/etc/apache2/conf.d'
                  end

      context 'with default parameters' do
        it { should contain_file("#{confd_dir}/05-foreman.d/test.conf").with_ensure(:absent) }
        it { should contain_file("#{confd_dir}/05-foreman-ssl.d/test.conf").with_ensure(:absent) }
      end

      context 'with content parameter' do
        let :params do
          { :content => '# config' }
        end

        it { should contain_file("#{confd_dir}/05-foreman.d/test.conf").with_content('# config') }
        it { should contain_file("#{confd_dir}/05-foreman-ssl.d/test.conf").with_ensure(:absent) }
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
