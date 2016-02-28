# This file is managed centrally by modulesync
#   https://github.com/theforeman/foreman-installer-modulesync

require 'puppetlabs_spec_helper/rake_tasks'
require 'puppet-lint/tasks/puppet-lint'

# blacksmith is broken with ruby 1.8.7
if Gem::Version.new(RUBY_VERSION) > Gem::Version.new('1.8.7')
  # blacksmith isn't always present, e.g. on Travis with --without development
  begin
    require 'puppet_blacksmith/rake_tasks'
    Blacksmith::RakeTask.new do |t|
      t.tag_pattern = "%s"
    end
  rescue LoadError
  end
end

PuppetLint.configuration.ignore_paths = ["spec/**/*.pp", "pkg/**/*.pp", "vendor/**/*.pp"]
PuppetLint.configuration.log_format = '%{path}:%{linenumber}:%{KIND}: %{message}'

require 'puppet-lint-param-docs/tasks'
PuppetLintParamDocs.define_selective do |config|
  config.pattern = ["manifests/cli.pp", "manifests/init.pp", "manifests/compute/*.pp", "manifests/plugin/*.pp"]
end

task :default => [:validate, :lint, :spec]
