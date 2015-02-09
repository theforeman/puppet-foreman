require 'spec_helper'

describe 'foreman::puppetmaster' do
  context 'RedHat' do
    let :facts do
      {
        :fqdn                   => 'hostname.example.org',
        :rubyversion            => '1.8.7',
        :osfamily               => 'RedHat',
        :operatingsystemrelease => '6.5',
      }
    end

    describe 'without custom parameters' do
      it 'should set up reports' do
        should contain_exec('Create Puppet Reports dir').with({
          :command => '/bin/mkdir -p /usr/lib/ruby/site_ruby/1.8/puppet/reports',
          :creates => '/usr/lib/ruby/site_ruby/1.8/puppet/reports',
        })

        should contain_file('/usr/lib/ruby/site_ruby/1.8/puppet/reports/foreman.rb').with({
          :mode    => '0644',
          :owner   => 'root',
          :group   => 'root',
          :source  => 'puppet:///modules/foreman/foreman-report_v2.rb',
          :require => 'Exec[Create Puppet Reports dir]',
        })
      end

      it 'should set up enc' do
        should contain_file('/etc/puppet/node.rb').with({
          :mode   => '0550',
          :owner  => 'puppet',
          :group  => 'puppet',
          :source => 'puppet:///modules/foreman/external_node_v2.rb',
        })
      end

      it 'should install json package' do
        should contain_package('rubygem-json').with_ensure('installed')
      end

      it 'should create puppet.yaml' do
        should contain_file('/etc/puppet/foreman.yaml').
          with_content(/^:url: "https:\/\/#{facts[:fqdn]}"$/).
          with_content(/^:ssl_ca: "\/var\/lib\/puppet\/ssl\/certs\/ca.pem"$/).
          with_content(/^:ssl_cert: "\/var\/lib\/puppet\/ssl\/certs\/#{facts[:fqdn]}.pem"$/).
          with_content(/^:ssl_key: "\/var\/lib\/puppet\/ssl\/private_keys\/#{facts[:fqdn]}.pem"$/).
          with_content(/^:user: ""$/).
          with_content(/^:password: ""$/).
          with_content(/^:puppetdir: "\/var\/lib\/puppet"$/).
          with_content(/^:facts: true$/).
          with_content(/^:timeout: 60$/).
          with({
            :mode  => '0640',
            :owner => 'root',
            :group => 'puppet',
          })
      end
    end

    describe 'without reports' do
      let :params do
        {:reports => false}
      end

      it 'should not include reports' do
        should_not contain_exec('Create Puppet Reports dir')

        should_not contain_file('/usr/lib/ruby/site_ruby/1.8/puppet/reports/foreman.rb')
      end
    end

    describe 'without enc' do
      let :params do
        {:enc => false}
      end

      it 'should not include enc' do
        should_not contain_file('/etc/puppet/node.rb')
      end
    end
  end

  context 'RedHat 7.x' do
    let :facts do
      {
        :fqdn                   => 'hostname.example.org',
        :rubyversion            => '2.0.0',
        :osfamily               => 'RedHat',
        :operatingsystemrelease => '7.0',
      }
    end

    describe 'without custom parameters' do
      it 'should set up reports' do
        should contain_exec('Create Puppet Reports dir').with({
          :command => '/bin/mkdir -p /usr/share/ruby/vendor_ruby/puppet/reports',
          :creates => '/usr/share/ruby/vendor_ruby/puppet/reports',
        })

        should contain_file('/usr/share/ruby/vendor_ruby/puppet/reports/foreman.rb').with({
          :mode    => '0644',
          :owner   => 'root',
          :group   => 'root',
          :source  => 'puppet:///modules/foreman/foreman-report_v2.rb',
          :require => 'Exec[Create Puppet Reports dir]',
        })
      end

      it 'should install json package' do
        should contain_package('rubygem-json').with_ensure('installed')
      end
    end
  end

  context 'Fedora' do
    let :facts do
      {
        :operatingsystem => 'Fedora',
        :osfamily        => 'RedHat',
      }
    end

    describe 'without custom parameters' do
      it 'should set up reports' do
        should contain_exec('Create Puppet Reports dir').with({
          :command => '/bin/mkdir -p /usr/share/ruby/vendor_ruby/puppet/reports',
          :creates => '/usr/share/ruby/vendor_ruby/puppet/reports',
        })

        should contain_file('/usr/share/ruby/vendor_ruby/puppet/reports/foreman.rb').with({
          :mode    => '0644',
          :owner   => 'root',
          :group   => 'root',
          :source  => 'puppet:///modules/foreman/foreman-report_v2.rb',
          :require => 'Exec[Create Puppet Reports dir]',
        })
      end

      it 'should install json package' do
        should contain_package('rubygem-json').with_ensure('installed')
      end
    end
  end

  context 'Amazon' do
    let :facts do
      {
        :operatingsystem => 'Amazon',
        :rubyversion     => '1.8.7',
        :osfamily        => 'Linux',
      }
    end

    describe 'without custom parameters' do
      it 'should set up reports' do
        should contain_exec('Create Puppet Reports dir').with({
          :command => '/bin/mkdir -p /usr/lib/ruby/site_ruby/1.8/puppet/reports',
          :creates => '/usr/lib/ruby/site_ruby/1.8/puppet/reports',
        })

        should contain_file('/usr/lib/ruby/site_ruby/1.8/puppet/reports/foreman.rb').with({
          :mode    => '0644',
          :owner   => 'root',
          :group   => 'root',
          :source  => 'puppet:///modules/foreman/foreman-report_v2.rb',
          :require => 'Exec[Create Puppet Reports dir]',
        })
      end

      it 'should install json package' do
        should contain_package('rubygem-json').with_ensure('installed')
      end
    end
  end

  context 'Debian' do
    let :facts do
      {
        :operatingsystem => 'Debian',
        :osfamily        => 'Debian',
      }
    end

    describe 'without custom parameters' do
      it 'should set up reports' do
        should contain_exec('Create Puppet Reports dir').with({
          :command => '/bin/mkdir -p /usr/lib/ruby/vendor_ruby/puppet/reports',
          :creates => '/usr/lib/ruby/vendor_ruby/puppet/reports',
        })

        should contain_file('/usr/lib/ruby/vendor_ruby/puppet/reports/foreman.rb').with({
          :mode    => '0644',
          :owner   => 'root',
          :group   => 'root',
          :source  => 'puppet:///modules/foreman/foreman-report_v2.rb',
          :require => 'Exec[Create Puppet Reports dir]',
        })
      end

      it 'should install json package' do
        should contain_package('ruby-json').with_ensure('installed')
      end
    end
  end
end
