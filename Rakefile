# frozen_string_literal: true

require "bundler/gem_tasks"
require "rubocop/rake_task"

RuboCop::RakeTask.new

task default: :rubocop

require "rake"
require "rubygems/package_task"

# Load gemspec
gemspec = Gem::Specification.load("skinbaron_api_client.gemspec")

# Task to build the gem
Rake::GemPackageTask.new(gemspec) do |pkg|
  pkg.need_tar = true
  pkg.need_zip = true
end

# Task to bump the version
desc "Bump gem version (usage: rake bump[patch|minor|major])"
task :bump, [:level] do |_, args|
  version_file = "lib/skinbaron_api_client/version.rb"
  level = args[:level] || "patch" # Default to patch
  version_line = File.read(version_file).match(/VERSION = "(.*?)"/)[1]
  major, minor, patch = version_line.split(".").map(&:to_i)

  case level
  when "major" then major += 1
                    minor = 0
                    patch = 0
  when "minor" then minor += 1
                    patch = 0
  else              patch += 1
  end

  new_version = "#{major}.#{minor}.#{patch}"
  puts "Bumping version to #{new_version}"

  # Update the version file
  File.write(version_file, File.read(version_file).gsub(/VERSION = "(.*?)"/, "VERSION = \"#{new_version}\""))

  # Commit and tag the new version
  `git add #{version_file}`
  `git commit -m "Bump version to #{new_version}"`
  `git tag -a v#{new_version} -m "Release version #{new_version}"`
  `git push origin main --tags`
end

# Task to release the gem
desc "Release the gem (build, push, and tag)"
task release: [:build] do
  gem_file = Dir["pkg/#{gemspec.name}-#{gemspec.version}.gem"].first
  abort "No gem file found. Run `rake build` first." if gem_file.nil?

  puts "Pushing #{gem_file} to RubyGems..."
  sh "gem push #{gem_file}"

  puts "Creating a Git tag..."
  sh "git tag -a v#{gemspec.version} -m 'Release version #{gemspec.version}'"
  sh "git push origin v#{gemspec.version}"
end
