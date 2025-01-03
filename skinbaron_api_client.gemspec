# lib/skinbaron_api_client.rb

# frozen_string_literal: true

require_relative "lib/skinbaron_api_client/version"

Gem::Specification.new do |spec|
  spec.name = "skinbaron_api_client"
  spec.version = SkinbaronApiClient::VERSION
  spec.authors = ["Sam Schams"]
  spec.email = ["94133186+shazam442@users.noreply.github.com"]

  spec.summary = "A simple ruby client for interacting with the SkinBaron API " \
                 "simplifying the access to item data and market data."

  spec.description = "A Ruby client library for the SkinBaron API - my first Ruby gem. " \
                    "Provides basic functionality for searching CS2 (formerly CS:GO) items " \
                    "on the SkinBaron marketplace. Includes error handling, request logging, " \
                    "and a straightforward API design for interacting with SkinBaron's marketplace data."
  spec.homepage = "https://github.com/shazam442/skinbaron-api-client"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.0.0"

  spec.metadata["allowed_push_host"] = "https://rubygems.org"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/shazam442/skinbaron-api-client"
  spec.metadata["changelog_uri"] = "https://github.com/shazam442/skinbaron-api-client/blob/main/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  gemspec = File.basename(__FILE__)
  spec.files = IO.popen(%w[git ls-files -z], chdir: __dir__, err: IO::NULL) do |ls|
    ls.readlines("\x0", chomp: true).reject do |f|
      (f == gemspec) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git appveyor Gemfile])
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "http", "~> 5.2"
  spec.add_runtime_dependency "logger", "~> 1.6", ">= 1.6.4"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
