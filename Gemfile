source 'https://rubygems.org'

if ENV.key?('PUPPET_VERSION')
  puppetversion = "~> #{ENV['PUPPET_VERSION']}"
else
  puppetversion = ['>= 2.6']
end

gem 'puppet',  puppetversion
gem 'puppet-lint', '>=0.3.2'
gem 'puppet-syntax'
gem 'puppetlabs_spec_helper', '>=0.2.0'
gem 'rspec-puppet', :git => 'https://github.com/rodjek/rspec-puppet.git', :ref => '891c5794f'
gem 'json'
gem 'webmock'
