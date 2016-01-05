require 'spec_helper'

describe 'foreman::config::passenger::fragment' do
  let(:title) { 'test' }

  on_supported_os.each do |os, facts|
    next if only_test_os() and not only_test_os.include?(os)
    next if exclude_test_os() and exclude_test_os.include?(os)

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

      context 'with ssl turned off' do
        let :pre_condition do
          "class { '::foreman::config::passenger':
              app_root      => '/usr/share/foreman',
              ssl           => false,
              user          => 'foreman',
              prestart      => true,
              min_instances => '1',
              start_timeout => '600',
              use_vhost     => true,
              foreman_url   => 'https://#{facts[:fqdn]}',
          }"
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
          it { should contain_file("#{confd_dir}/05-foreman-ssl.d/test.conf").with_ensure(:absent) }
        end
      end

      context 'with ssl turned on' do
        let :pre_condition do
          "class { '::foreman::config::passenger':
              app_root      => '/usr/share/foreman',
              ssl           => true,
              user          => 'foreman',
              prestart      => true,
              min_instances => '1',
              start_timeout => '600',
              use_vhost     => true,
              foreman_url   => 'https://#{facts[:fqdn]}',
          }"
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
