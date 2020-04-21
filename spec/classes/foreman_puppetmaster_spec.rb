require 'spec_helper'

describe 'foreman::puppetmaster' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let :facts do
        if (facts[:osfamily] == 'RedHat') && (facts[:operatingsystemmajrelease] == '6')
          facts[:rubyversion] = '1.8.7'
        end

        facts
      end

      describe 'without custom parameters' do
        case facts[:osfamily]
        when 'RedHat'
          site_ruby = case facts[:operatingsystemmajrelease]
                      when '6'
                        '/usr/lib/ruby/site_ruby/1.8'
                      else
                        '/usr/share/ruby/vendor_ruby'
                      end
          json_package = 'rubygem-json'
          etc_dir = '/etc'
          puppet_vardir = '/var/lib/puppet'
        when 'Debian'
          site_ruby = '/usr/lib/ruby/vendor_ruby'
          json_package = 'ruby-json'
          etc_dir = '/etc'
          puppet_vardir = '/var/lib/puppet'
        when 'FreeBSD'
          site_ruby = '/usr/local/lib/ruby/site_ruby/2.1'
          json_package = 'rubygem-json'
          etc_dir = '/usr/local/etc'
          puppet_vardir = '/var/puppet'
        end

        it 'should set up reports' do
          should contain_exec('Create Puppet Reports dir')
            .with_command("/bin/mkdir -p #{site_ruby}/puppet/reports")
            .with_creates("#{site_ruby}/puppet/reports")

          should contain_file("#{site_ruby}/puppet/reports/foreman.rb")
            .with_mode('0644')
            .with_owner('root')
            .with_group('0')
            .with_source('puppet:///modules/foreman/foreman-report_v2.rb')
            .with_require('Exec[Create Puppet Reports dir]')
        end

        it 'should set up enc' do
          should contain_file("#{etc_dir}/puppet/node.rb")
            .with_mode('0550')
            .with_owner('puppet')
            .with_group('puppet')
            .with_source('puppet:///modules/foreman/external_node_v2.rb')
        end

        it 'should install json package' do
          should contain_package(json_package).with_ensure('present')
        end

        it 'should create puppet.yaml' do
          should contain_file("#{etc_dir}/puppet/foreman.yaml")
            .with_mode('0640')
            .with_owner('root')
            .with_group('puppet')

          verify_exact_contents(catalogue, "#{etc_dir}/puppet/foreman.yaml", [
            "---",
            ":url: \"https://#{facts[:fqdn]}\"",
            ":ssl_ca: \"#{puppet_vardir}/ssl/certs/ca.pem\"",
            ":ssl_cert: \"#{puppet_vardir}/ssl/certs/#{facts[:fqdn]}.pem\"",
            ":ssl_key: \"#{puppet_vardir}/ssl/private_keys/#{facts[:fqdn]}.pem\"",
            ":puppetdir: \"#{puppet_vardir}\"",
            ':puppetuser: "puppet"',
            ':facts: true',
            ':timeout: 60',
            ':report_timeout: 60',
            ':threads: null',
          ])
        end
      end

      describe 'without reports' do
        let :params do
          { reports: false }
        end

        it 'should not include reports' do
          should_not contain_exec('Create Puppet Reports dir')

          should_not contain_file('/usr/lib/ruby/site_ruby/1.8/puppet/reports/foreman.rb')
        end
      end

      describe 'without enc' do
        let :params do
          { enc: false }
        end

        it 'should not include enc' do
          should_not contain_file('/etc/puppet/node.rb')
        end
      end
    end
  end

  # TODO: on_supported_os?
  context 'Amazon' do
    let :facts do
      {
        operatingsystem: 'Amazon',
        rubyversion: '1.8.7',
        osfamily: 'Linux',
        puppetversion: Puppet.version,
        rubysitedir: '/usr/lib/ruby/site_ruby'
      }
    end

    describe 'without custom parameters' do
      it 'should set up reports' do
        should contain_exec('Create Puppet Reports dir')
          .with_command('/bin/mkdir -p /usr/lib/ruby/site_ruby/1.8/puppet/reports')
          .with_creates('/usr/lib/ruby/site_ruby/1.8/puppet/reports')

        should contain_file('/usr/lib/ruby/site_ruby/1.8/puppet/reports/foreman.rb')
          .with_mode('0644')
          .with_owner('root')
          .with_group('0')
          .with_source('puppet:///modules/foreman/foreman-report_v2.rb')
          .with_require('Exec[Create Puppet Reports dir]')
      end

      it 'should install json package' do
        should contain_package('rubygem-json').with_ensure('present')
      end
    end
  end
end
