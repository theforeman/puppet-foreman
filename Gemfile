# This file is managed centrally by modulesync
#   https://github.com/theforeman/foreman-installer-modulesync

source 'https://rubygems.org'

gem 'puppet', ENV.key?('PUPPET_VERSION') ? "~> #{ENV['PUPPET_VERSION']}" : '>= 2.7'

gem 'rake'
gem 'rspec-puppet', '>= 1'
gem 'puppetlabs_spec_helper', '>= 0.8.0'
gem 'puppet-lint', '>= 1'
gem 'simplecov'
gem 'puppet-blacksmith', '>= 3.1.0', {"groups"=>["development"]}
gem 'rest-client', '< 1.7', {"platforms"=>["ruby_18"], "groups"=>["development"]}
gem 'mime-types', '~> 1.0', {"platforms"=>["ruby_18"], "groups"=>["development"]}
gem 'json'
gem 'webmock'

# vim:ft=ruby
