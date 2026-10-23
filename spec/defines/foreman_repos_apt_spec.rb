require 'spec_helper'

describe 'foreman::repos::apt' do
  let(:title) { 'foreman' }

  on_supported_os.each do |os, os_facts|
    next unless os_facts[:os]['family'] == 'Debian'

    context "on #{os}" do
      let(:facts) { os_facts }

      ['5.0', 'nightly'].each do |repo|
        context "with repo => #{repo}" do
          let(:params) { { repo: repo } }

          it { is_expected.to compile.with_all_deps }
          it { is_expected.to contain_class('apt') }
          it 'does not manage keys through apt-key' do
            is_expected.to have_apt__key_resource_count(0)
            is_expected.to have_apt_key_resource_count(0)
          end

          ['foreman', 'foreman-plugins'].each do |source_name|
            release = source_name == 'foreman' ? os_facts[:os]['distro']['codename'] : 'plugins'
            keyring_path = "/etc/apt/keyrings/#{source_name}.asc"

            it "adds the #{source_name} repository with its keyring" do
              is_expected.to contain_apt__source(source_name)
                .with_location('https://deb.theforeman.org/')
                .with_repos(repo)
                .with_key('name' => "#{source_name}.asc", 'source' => 'https://deb.theforeman.org/foreman.asc')

              is_expected.to contain_apt__source(source_name).with_release('plugins') if source_name == 'foreman-plugins'

              entry = "deb [signed-by=#{keyring_path}] https://deb.theforeman.org/ #{release} #{repo}"
              is_expected.to contain_file("/etc/apt/sources.list.d/#{source_name}.list")
                .with_content(/^#{Regexp.escape(entry)}$/)

              is_expected.to contain_apt__keyring("#{source_name}.asc")
                .with_source('https://deb.theforeman.org/foreman.asc')

              is_expected.to contain_file(keyring_path)
                .with_source('https://deb.theforeman.org/foreman.asc')
                .with_mode('0644')
            end
          end
        end
      end
    end
  end
end
