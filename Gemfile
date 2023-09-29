# This file is managed centrally by modulesync
#   https://github.com/theforeman/foreman-installer-modulesync

source 'https://rubygems.org'

gem 'puppet', ENV.fetch('PUPPET_GEM_VERSION', '>= 7'), groups: ['development', 'test']
gem 'rake'

gem 'kafo_module_lint', {"groups"=>["test"]}
gem 'puppet-lint-spaceship_operator_without_tag-check', '~> 1.0', {"groups"=>["test"]}
gem 'voxpupuli-test', '~> 7.0', {"groups"=>["test"]}
gem 'github_changelog_generator', '>= 1.15.0', {"groups"=>["development"]}
gem 'puppet_metadata', '~> 3.3'
gem 'puppet-blacksmith', '>= 6.0.0', {"groups"=>["development"]}
gem 'voxpupuli-acceptance', '~> 2.0', {"groups"=>["system_tests"]}
gem 'puppetlabs_spec_helper', {"groups"=>["system_tests"]}
gem 'webmock', '~> 2.0'
gem 'oauth'

# vim:ft=ruby
