require 'puppetlabs_spec_helper/rake_tasks'
require 'puppet-lint/tasks/puppet-lint'
require 'puppet-syntax/tasks/puppet-syntax'

exclude_paths = ["spec/**/*", "vendor/**/*"]

PuppetLint.configuration.ignore_paths = exclude_paths
PuppetLint.configuration.log_format = '%{path}:%{linenumber}:%{KIND}: %{message}'
PuppetLint.configuration.fail_on_warnings = true
PuppetLint.configuration.relative = true
PuppetLint.configuration.send("disable_class_inherits_from_params_class")
PuppetLint.configuration.send("disable_80chars")
PuppetLint.configuration.send("disable_documentation")

PuppetSyntax.exclude_paths = exclude_paths

if ENV['PARSER'] == 'future'
  puts "Enabling future parser"
  PuppetSyntax.future_parser = true
end

task :default => [:'syntax:manifests', :lint, :spec]
