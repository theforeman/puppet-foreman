require 'spec_helper'

describe 'foreman::repos::apt' do
  let(:title) { 'foreman' }

  let :facts do
    on_supported_os['debian-12-x86_64']
  end

  let(:apt_keyring_title) do
    "foreman.asc"
  end

  let(:apt_keyring_source) do
    "https://deb.theforeman.org/foreman.asc"
  end

  context 'with repo => 3.13' do
    let(:params) { { repo: '3.13' } }

    it { should contain_class('apt') }

    it 'should add the 3.13 repo' do
      should contain_apt__source('foreman')
        .with_location('https://deb.theforeman.org/')
        .with_repos('3.13')

      should contain_file('/etc/apt/sources.list.d/foreman.list')
        .with_content(%r{deb \[signed-by=/etc/apt/keyrings/foreman\.asc\] https://deb\.theforeman\.org/ bookworm 3\.13})

      should contain_apt__source('foreman-plugins')
        .with_location('https://deb.theforeman.org/')
        .with_release('plugins')
        .with_repos('3.13')
    end

    it { should contain_apt__keyring(apt_keyring_title).with_source(apt_keyring_source) }
  end

  context 'with repo => nightly' do
    let(:params) { { repo: 'nightly' } }

    it { should contain_class('apt') }

    it 'should add the nightly repo' do
      should contain_apt__source('foreman')
        .with_location('https://deb.theforeman.org/')
        .with_repos('nightly')

      should contain_file('/etc/apt/sources.list.d/foreman.list')
        .with_content(%r{deb \[signed-by=/etc/apt/keyrings/foreman\.asc\] https://deb\.theforeman\.org/ bookworm nightly})

      should contain_apt__source('foreman-plugins')
        .with_location('https://deb.theforeman.org/')
        .with_release('plugins')
        .with_repos('nightly')
    end

    it { should contain_apt__keyring(apt_keyring_title).with_source(apt_keyring_source) }
  end
end
