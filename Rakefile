# This file is managed centrally by modulesync
#   https://github.com/theforeman/foreman-installer-modulesync

require 'puppetlabs_spec_helper/rake_tasks'
require 'puppet-lint/tasks/puppet-lint'

# blacksmith isn't always present, e.g. on Travis with --without development
begin
  require 'puppet_blacksmith/rake_tasks'
  Blacksmith::RakeTask.new do |t|
    t.tag_pattern = "%s"
  end
rescue LoadError
end

PuppetLint.configuration.ignore_paths = ["spec/**/*.pp", "pkg/**/*.pp", "vendor/**/*.pp"]
PuppetLint.configuration.log_format = '%{path}:%{line}:%{KIND}: %{message}'

require 'puppet-lint-param-docs/tasks'
PuppetLintParamDocs.define_selective do |config|
  config.pattern = ["manifests/cli.pp", "manifests/cli/*.pp", "manifests/init.pp", "manifests/compute/*.pp", "manifests/plugin/*.pp"]
end

require 'kafo_module_lint/tasks'
KafoModuleLint::RakeTask.new do |config|
  config.pattern = ["manifests/cli.pp", "manifests/cli/*.pp", "manifests/init.pp", "manifests/compute/*.pp", "manifests/plugin/*.pp"]
end

task :default => [:release_checks]
