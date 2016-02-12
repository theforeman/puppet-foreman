# This file is managed centrally by modulesync
#   https://github.com/theforeman/foreman-installer-modulesync

source 'https://rubygems.org'

gem 'puppet', ENV.key?('PUPPET_VERSION') ? "~> #{ENV['PUPPET_VERSION']}" : '>= 2.7'

if RUBY_VERSION.start_with? '1.8'
  gem 'rspec', '>= 3', '< 3.2'
  gem 'rspec-puppet-facts', '< 1.4.0'
else
  gem 'rspec', '~> 3.0'
  gem 'rspec-puppet-facts'
end
gem 'rake'
gem 'rspec-puppet', '~> 2.3'
gem 'puppetlabs_spec_helper', '>= 0.8.0'
gem 'puppet-lint', '>= 1'
gem 'puppet-lint-unquoted_string-check'
gem 'puppet-lint-empty_string-check'
gem 'puppet-lint-spaceship_operator_without_tag-check'
gem 'puppet-lint-variable_contains_upcase'
gem 'puppet-lint-absolute_classname-check'
gem 'puppet-lint-undef_in_function-check'
gem 'puppet-lint-leading_zero-check'
gem 'puppet-lint-trailing_comma-check'
gem 'puppet-lint-file_ensure-check'
gem 'puppet-lint-param-docs', '>= 1.3.0'
gem 'simplecov'
gem 'puppet-blacksmith', '>= 3.1.0', {"groups"=>["development"]}
gem 'rest-client', '< 1.7', {"platforms"=>["ruby_18"], "groups"=>["development"]}
gem 'mime-types', '~> 1.0', {"platforms"=>["ruby_18"], "groups"=>["development"]}
gem 'metadata-json-lint'
gem 'json'
gem 'webmock'
gem 'addressable', '< 2.4', {"platforms"=>["ruby_18"]}

# vim:ft=ruby
