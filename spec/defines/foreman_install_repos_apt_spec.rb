require 'spec_helper'


describe 'foreman::install::repos::apt' do
  let(:title) { 'foreman' }

  let :facts do
    {
      :lsbdistcodename => 'squeeze',
    }
  end

  context 'with repo => stable' do
    let(:params) { {:repo => 'stable'} }

    it 'should add the stable repo' do
      should contain_file('/etc/apt/sources.list.d/foreman.list') \
        .with_content("deb http://deb.theforeman.org/ squeeze stable\ndeb http://deb.theforeman.org/ plugins stable\n")
    end
  end

  context 'with repo => rc' do
    let(:params) { {:repo => 'rc'} }

    it 'should add the rc repo' do
      should contain_file('/etc/apt/sources.list.d/foreman.list') \
        .with_content("deb http://deb.theforeman.org/ squeeze rc\ndeb http://deb.theforeman.org/ plugins rc\n")
    end
  end

  context 'with repo => nightly' do
    let(:params) { {:repo => 'nightly'} }

    it 'should add the nightly repo' do
      should contain_file('/etc/apt/sources.list.d/foreman.list') \
        .with_content("deb http://deb.theforeman.org/ squeeze nightly\ndeb http://deb.theforeman.org/ plugins nightly\n")
    end
  end

end
