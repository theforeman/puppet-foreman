require 'spec_helper'

describe 'foreman::repos::apt' do
  let(:title) { 'foreman' }

  let :facts do
    on_supported_os['debian-12-x86_64']
  end

  let(:apt_key) do
    '5B7C3E5A735BCB4D615829DC0BDDA991FD7AAC8A'
  end

  let(:apt_key_title) do
    "foreman"
  end

  context 'with repo => 3.13' do
    let(:params) { { repo: '3.13' } }

    it { should contain_class('apt') }

    it 'should add the 3.13 repo' do
      should contain_apt__source('foreman')
        .with_location('https://deb.theforeman.org/')
        .with_repos('3.13')

      should contain_file('/etc/apt/sources.list.d/foreman.list')
        .with_content(%r{deb https://deb\.theforeman\.org/ bookworm 3\.13})

      should contain_apt__source('foreman-plugins')
        .with_location('https://deb.theforeman.org/')
        .with_release('plugins')
        .with_repos('3.13')
    end

    it { should contain_apt_key(apt_key_title).with_id(apt_key) }
  end

  context 'with repo => nightly' do
    let(:params) { { repo: 'nightly' } }

    it { should contain_class('apt') }

    it 'should add the nightly repo' do
      should contain_apt__source('foreman')
        .with_location('https://deb.theforeman.org/')
        .with_repos('nightly')

      should contain_file('/etc/apt/sources.list.d/foreman.list')
        .with_content(%r{deb https://deb\.theforeman\.org/ bookworm nightly})

      should contain_apt__source('foreman-plugins')
        .with_location('https://deb.theforeman.org/')
        .with_release('plugins')
        .with_repos('nightly')
    end

    it { should contain_apt_key(apt_key_title).with_id(apt_key) }
  end
end
