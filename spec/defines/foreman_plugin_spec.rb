require 'spec_helper'

describe 'foreman::plugin' do
  let :title do 'myplugin' end

  context 'no parameters' do
    let :pre_condition do
      'include foreman'
    end

    let :facts do {
      :concat_basedir         => '/nonexistant',
      :operatingsystem        => 'RedHat',
      :operatingsystemrelease => '6.4',
      :osfamily               => 'RedHat',
    } end

    it 'should install the correct package' do
      should contain_package('ruby193-rubygem-foreman_myplugin').with_ensure('installed')
    end

    it 'should not contain the config file' do
      should_not contain_file('/etc/foreman/plugins/foreman_myplugin.yaml')
    end
  end

  context 'with package parameter' do
    let :params do {
      :package => 'myplugin',
    } end

    it 'should install the correct package' do
      should contain_package('myplugin').with_ensure('installed')
    end
  end

  context 'when handling underscores on Red Hat' do
    let :params do {
      :package => 'my_fun_plugin',
    } end

    it 'should use underscores' do
      should contain_package('my_fun_plugin').with_ensure('installed')
    end
  end

  context 'when handling underscores on Debian' do
    let :facts do {
      :osfamily => 'Debian',
    } end

    let :params do {
      :package => 'my_fun_plugin',
    } end

    it 'should use hyphens' do
      should contain_package('my-fun-plugin').with_ensure('installed')
    end
  end

  context 'when specifying a config' do
    let :pre_condition do
      'include foreman'
    end

    let :facts do {
      :concat_basedir         => '/nonexistant',
      :operatingsystem        => 'Debian',
      :operatingsystemrelease => '7.0',
      :osfamily               => 'Debian',
    } end

    let :params do {
      :config => 'the config content',
    } end

    it 'should contain the config file' do
      should contain_file('/etc/foreman/plugins/foreman_myplugin.yaml').
        with_ensure('file').
        with_owner('root').
        with_group('root').
        with_mode('0644').
        with_content('the config content').
        with_require('Package[ruby-foreman-myplugin]')
    end
  end
end
