# This file is managed centrally by modulesync
#   https://github.com/theforeman/foreman-installer-modulesync

require 'voxpupuli/test/rake'

# We use fixtures in our modules, which is not the default
task :beaker => 'spec_prep'

# blacksmith isn't always present, e.g. on Travis with --without development
begin
  require 'puppet_blacksmith/rake_tasks'
  Blacksmith::RakeTask.new do |t|
    t.tag_pattern = "%s"
    t.tag_message_pattern = "Version %s"
    t.tag_sign = true
  end
rescue LoadError
end

begin
  require 'github_changelog_generator/task'

  # https://github.com/github-changelog-generator/github-changelog-generator/issues/313
  module GitHubChangelogGeneratorExtensions
    def compound_changelog
      super.gsub(/(fixes|fixing|refs) \\#(\d+)/i, '\1 [\\#\2](https://projects.theforeman.org/issues/\2)')
    end
  end

  class GitHubChangelogGenerator::Generator
    prepend GitHubChangelogGeneratorExtensions
  end

  GitHubChangelogGenerator::RakeTask.new :changelog do |config|
    raise "Set CHANGELOG_GITHUB_TOKEN environment variable eg 'export CHANGELOG_GITHUB_TOKEN=valid_token_here'" if Rake.application.top_level_tasks.include? "changelog" and ENV['CHANGELOG_GITHUB_TOKEN'].nil?
    metadata = JSON.load(File.read('metadata.json'))
    config.user = 'theforeman'
    config.project = "puppet-#{metadata['name'].split('-').last}"
    config.future_release = metadata['version']
    config.exclude_labels = ['duplicate', 'question', 'invalid', 'wontfix', 'Modulesync', 'skip-changelog']
  end
rescue LoadError
end
