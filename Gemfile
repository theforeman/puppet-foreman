# This file is managed centrally by modulesync
#   https://github.com/theforeman/foreman-installer-modulesync

source 'https://rubygems.org'

gem 'puppet', ENV.key?('PUPPET_VERSION') ? "~> #{ENV['PUPPET_VERSION']}" : '>= 4.6'

gem 'rake'
gem 'rspec', '~> 3.0'
gem 'rspec-puppet', '~> 2.3'
gem 'rspec-puppet-facts', '>= 1.7'
gem 'puppetlabs_spec_helper', '>= 2.1.1'
gem 'puppet-lint', '>= 2'
gem 'puppet-lint-absolute_classname-check'
gem 'puppet-lint-classes_and_types_beginning_with_digits-check'
gem 'puppet-lint-empty_string-check'
gem 'puppet-lint-file_ensure-check'
gem 'puppet-lint-leading_zero-check'
gem 'puppet-lint-param-docs', '>= 1.3.0'
gem 'puppet-lint-spaceship_operator_without_tag-check'
gem 'puppet-lint-strict_indent-check'
gem 'puppet-lint-trailing_comma-check'
gem 'puppet-lint-undef_in_function-check'
gem 'puppet-lint-unquoted_string-check'
gem 'puppet-lint-variable_contains_upcase'
gem 'puppet-lint-version_comparison-check'
gem 'simplecov'
gem 'puppet-blacksmith', '>= 3.1.0', {"groups"=>["development"]}
gem 'beaker', '>= 3.9.0', {"groups"=>["system_tests"]}
gem 'beaker-rspec', {"groups"=>["system_tests"]}
gem 'beaker-module_install_helper', {"groups"=>["system_tests"]}
gem 'beaker-puppet_install_helper', {"groups"=>["system_tests"]}
gem 'metadata-json-lint'
gem 'kafo_module_lint'
gem 'rgen'
gem 'parallel_tests'
gem 'webmock', '~> 2.0'
gem 'oauth'

# vim:ft=ruby
