require 'spec_helper'

describe 'foreman::plugin::discovery' do
  let :facts do
    {
        :osfamily => 'RedHat',
        :operatingsystem => 'Fedora',
    }
  end

  context 'with enabled image installation' do
    let :params do
      {
          :install_images => true
      }
    end

    it 'should call the plugin' do
      should contain_foreman__plugin('discovery')
    end

    it 'should download and install tarball' do
      should contain_foreman__remote_file("/var/lib/tftpboot/boot/fdi-image-latest.tar").
        with_remote_location('http://downloads.theforeman.org/discovery/releases/latest/fdi-image-latest.tar')
    end
    
    it 'should extract the tarball' do
      should contain_exec('untar fdi-image-latest.tar').with({
        'command'     => "tar xf fdi-image-latest.tar",
        'path'        => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
        'cwd'         => '/var/lib/tftpboot/boot',
        'creates'     => "/var/lib/tftpboot/boot/fdi-image/initrd0.img",
      })
    end

  end

  context 'with disabled image installation' do
    let :params do
      {
          :install_images => false
      }
    end

    it 'should call the plugin' do
      should contain_foreman__plugin('discovery')
    end

    it 'should not download and install tarball' do
      should_not contain_foreman__remote_file("/var/lib/tftpboot/boot/fdi-image-latest.tar")
    end
  end
end
