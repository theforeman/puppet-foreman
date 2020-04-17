# This file is managed centrally by modulesync
#   https://github.com/theforeman/foreman-installer-modulesync

source 'https://rubygems.org'

gem 'puppet', ENV.key?('PUPPET_VERSION') ? "~> #{ENV['PUPPET_VERSION']}" : '>= 5.5'

gem 'kafo_module_lint'
gem 'puppet-lint-empty_string-check'
gem 'puppet-lint-file_ensure-check'
gem 'puppet-lint-param-docs', '>= 1.3.0'
gem 'puppet-lint-spaceship_operator_without_tag-check'
gem 'puppet-lint-strict_indent-check'
gem 'puppet-lint-undef_in_function-check'
gem 'voxpupuli-test', '~> 1.3'
gem 'github_changelog_generator', '>= 1.15.0', {"groups"=>["development"]}
gem 'puppet-blacksmith', '>= 4.1.0', {"groups"=>["development"]}
gem 'voxpupuli-acceptance', '~> 0.1', {"groups"=>["system_tests"]}
gem 'beaker-hiera', {"git"=>"https://github.com/ekohl/beaker-hiera", "branch"=>"fix", "groups"=>["system_tests"]}
gem 'webmock', '~> 2.0'
gem 'oauth'

# vim:ft=ruby
