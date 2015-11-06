require 'spec_helper'

describe 'foreman::plugin::discovery' do
  on_supported_os.each do |os, facts|
    let(:facts) { facts }

    context "on #{os}" do

      it { should contain_foreman__plugin('discovery') }

      describe 'without paramaters' do
        it { should_not contain_foreman__remote_file('/var/lib/tftpboot/boot/fdi-image-latest.tar') }
      end

      describe 'with install_images => true' do
        let :params do
          {
            :install_images => true
          }
        end

        it 'should download and install tarball' do
          should contain_foreman__remote_file('/var/lib/tftpboot/boot/fdi-image-latest.tar').
            with_remote_location('http://downloads.theforeman.org/discovery/releases/latest/fdi-image-latest.tar')
        end

        it 'should extract the tarball' do
          should contain_exec('untar fdi-image-latest.tar').with({
            'command' => 'tar xf fdi-image-latest.tar',
            'path' => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
            'cwd' => '/var/lib/tftpboot/boot',
            'creates' => '/var/lib/tftpboot/boot/fdi-image/initrd0.img',
          })
        end
      end
    end
  end
end
