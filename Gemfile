source 'https://rubygems.org'

if ENV.key?('PUPPET_VERSION')
  puppetversion = "~> #{ENV['PUPPET_VERSION']}"
else
  puppetversion = ['>= 2.6']
end

gem 'rake', '< 10.2.0' if RUBY_VERSION =~ /^1.8/
gem 'puppet',  puppetversion
gem 'puppet-lint', '>=0.3.2'
gem 'puppetlabs_spec_helper', '>=0.2.0'
gem 'rspec-puppet', '>= 1'
gem 'json'
gem 'webmock'
