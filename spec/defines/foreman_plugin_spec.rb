require 'spec_helper'

describe 'foreman::plugin' do
  let :title do 'myplugin' end

  on_os_under_test.each do |os, facts|
    context "on #{os}" do
      let :facts do facts end

      let :pre_condition do
        'include foreman'
      end

      context 'no parameters' do
        package_name = case facts[:osfamily]
                       when 'RedHat'
                         facts[:operatingsystem] == 'Fedora' ? 'rubygem-foreman_myplugin' : 'tfm-rubygem-foreman_myplugin'
                       when 'Debian'
                         'ruby-foreman-myplugin'
                       end
        it { should compile.with_all_deps }
        it { should contain_package(package_name).with_ensure('present') }
        it { should_not contain_file('/etc/foreman/plugins/foreman_myplugin.yaml') }
        it do
          should contain_foreman__plugin('myplugin')
            .that_comes_before('Class[foreman::database]')
            .that_notifies('Class[foreman::service]')
        end
      end

      context 'with package parameter' do
        let :params do
          {
            package: 'myplugin'
          }
        end

        it 'should install the correct package' do
          should contain_package('myplugin').with_ensure('present')
        end
      end

      context 'when handling underscores' do
        let :params do
          {
            package: 'my_fun_plugin'
          }
        end

        package_name = case facts[:osfamily]
                       when 'RedHat'
                         'my_fun_plugin'
                       when 'Debian'
                         'my-fun-plugin'
                       end

        it 'should use underscores' do
          should contain_package(package_name).with_ensure('present')
        end
      end

      context 'when specifying a config' do
        let :params do
          {
            config: 'the config content',
            package: 'myplugin'
          }
        end

        it 'should contain the config file' do
          should contain_file('/etc/foreman/plugins/foreman_myplugin.yaml')
            .with_ensure('file')
            .with_owner('root')
            .with_group('foreman')
            .with_mode('0640')
            .with_content('the config content')
            .that_requires('Package[myplugin]')
        end
      end
    end
  end
end
