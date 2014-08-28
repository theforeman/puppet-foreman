require 'spec_helper'

describe 'foreman::plugin::templates' do
  let :facts do
    {
      :concat_basedir            => '/tmp',
      :interfaces                => '',
      :puppet_vardir             => '/tmp',
      :id                        => 'root',
      :path                      => '/tmp',
      :kernel                    => 'Linux',
      :operatingsystem           => 'RedHat',
      :operatingsystemrelease    => '6.4',
      :operatingsystemmajrelease => '6',
      :osfamily                  => 'RedHat',
      :rubyversion               => '1.8.7',
      :selinux                   => 'true',
      :lsbdistcodename           => 'Santiago',
    }
  end

  it 'should call the plugin' do
    should contain_foreman__plugin('templates')
  end
end
