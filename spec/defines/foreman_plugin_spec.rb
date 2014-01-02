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

    it 'should install the correct package with notify' do
      should contain_package('ruby193-rubygem-foreman_myplugin').with({
        :ensure => 'installed',
        :notify => 'Class[Foreman::Service]',
      })
    end
  end

  context 'with package parameter' do
    let :params do {
      :package => 'myplugin',
    } end

    it 'should install the correct package with notify' do
      should contain_package('myplugin').with({
        :ensure => 'installed',
        :notify => 'Class[Foreman::Service]',
      })
    end
  end
end
