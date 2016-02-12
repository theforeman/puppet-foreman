require 'spec_helper'

describe 'foreman::install::repos::apt' do
  let(:title) { 'foreman' }

  let :facts do
    on_supported_os['debian-7-x86_64']
  end

  context 'with repo => stable' do
    let(:params) { {:repo => 'stable'} }

    it 'should add the stable repo' do
      should contain_file('/etc/apt/sources.list.d/foreman.list') \
        .with_content("deb http://deb.theforeman.org/ wheezy stable\ndeb http://deb.theforeman.org/ plugins stable\n")
    end
  end

  context 'with repo => 1.7' do
    let(:params) { {:repo => '1.7'} }

    it 'should add the 1.7 repo' do
      should contain_file('/etc/apt/sources.list.d/foreman.list') \
        .with_content("deb http://deb.theforeman.org/ wheezy 1.7\ndeb http://deb.theforeman.org/ plugins 1.7\n")
    end
  end

  context 'with repo => nightly' do
    let(:params) { {:repo => 'nightly'} }

    it 'should add the nightly repo' do
      should contain_file('/etc/apt/sources.list.d/foreman.list') \
        .with_content("deb http://deb.theforeman.org/ wheezy nightly\ndeb http://deb.theforeman.org/ plugins nightly\n")
    end
  end

end
