# This file is managed centrally by modulesync
#   https://github.com/theforeman/foreman-installer-modulesync

source 'https://rubygems.org'

gem 'puppet', ENV['PUPPET_GEM_VERSION'] || '>= 5.5', groups: ['development', 'test']
gem 'rake'

gem 'kafo_module_lint', {"groups"=>["test"]}
gem 'puppet-lint-empty_string-check', {"groups"=>["test"]}
gem 'puppet-lint-file_ensure-check', {"groups"=>["test"]}
gem 'puppet-lint-param-docs', '>= 1.3.0', {"groups"=>["test"]}
gem 'puppet-lint-spaceship_operator_without_tag-check', {"groups"=>["test"]}
gem 'puppet-lint-strict_indent-check', {"groups"=>["test"]}
gem 'puppet-lint-undef_in_function-check', {"groups"=>["test"]}
gem 'voxpupuli-test', '~> 1.4', {"groups"=>["test"]}
gem 'github_changelog_generator', '>= 1.15.0', {"groups"=>["development"]}
gem 'puppet_metadata', '~> 1.3'
gem 'puppet-blacksmith', '>= 6.0.0', {"groups"=>["development"]}
gem 'voxpupuli-acceptance', '~> 1.0', {"groups"=>["system_tests"]}
gem 'puppetlabs_spec_helper', {"groups"=>["system_tests"]}
gem 'webmock', '~> 2.0'
gem 'oauth'

# Pin rdoc to prevent updating bundled psych (https://github.com/ruby/rdoc/commit/ebe185c8775b2afe844eb3da6fa78adaa79e29a4)
gem 'rdoc', '< 6.4'

# vim:ft=ruby
