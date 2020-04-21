require 'spec_helper'

describe 'foreman::puppetmaster' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) { facts  }
      let(:site_ruby) { '/opt/puppetlabs/puppet/lib/ruby/vendor_ruby' }
      let(:etc_dir) { '/etc/puppetlabs/puppet' }
      let(:ssl_dir) { '/etc/puppetlabs/puppet/ssl' }
      let(:var_dir) { '/opt/puppetlabs/server/data/puppetserver' }
      let(:json_package) { facts[:os]['family'] == 'Debian' ? 'ruby-json' : 'rubygem-json' }

      describe 'without custom parameters' do
        it { should contain_class('foreman::puppetmaster::params') }

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
          should contain_file("#{etc_dir}/node.rb")
            .with_mode('0550')
            .with_owner('puppet')
            .with_group('puppet')
            .with_source('puppet:///modules/foreman/external_node_v2.rb')
        end

        it 'should set up directories for the ENC' do
          should contain_file("#{var_dir}/yaml")
            .with_ensure('directory')
            .with_owner('puppet')
            .with_group('puppet')
            .with_mode('0750')
          should contain_file("#{var_dir}/yaml/facts")
            .with_ensure('directory')
            .with_owner('puppet')
            .with_group('puppet')
            .with_mode('0750')
          should contain_file("#{var_dir}/yaml/foreman")
            .with_ensure('directory')
            .with_owner('puppet')
            .with_group('puppet')
            .with_mode('0750')
          should contain_file("#{var_dir}/yaml/node")
            .with_ensure('directory')
            .with_owner('puppet')
            .with_group('puppet')
            .with_mode('0750')
        end

        it 'should install json package' do
          should contain_package(json_package).with_ensure('present')
        end

        it 'should create puppet.yaml' do
          should contain_file("#{etc_dir}/foreman.yaml")
            .with_mode('0640')
            .with_owner('root')
            .with_group('puppet')

          verify_exact_contents(catalogue, "#{etc_dir}/foreman.yaml", [
            "---",
            ":url: \"https://#{facts[:fqdn]}\"",
            ":ssl_ca: \"#{ssl_dir}/certs/ca.pem\"",
            ":ssl_cert: \"#{ssl_dir}/certs/#{facts[:fqdn]}.pem\"",
            ":ssl_key: \"#{ssl_dir}/private_keys/#{facts[:fqdn]}.pem\"",
            ":puppetdir: \"#{var_dir}\"",
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
          should_not contain_file("#{site_ruby}/puppet/reports/foreman.rb")
        end
      end

      describe 'without enc' do
        let :params do
          { enc: false }
        end

        it 'should not include enc' do
          should_not contain_file("#{etc_dir}/node.rb")
        end
      end
    end
  end
end
