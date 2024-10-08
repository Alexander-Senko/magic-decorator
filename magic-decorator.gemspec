# frozen_string_literal: true

require_relative 'lib/magic/decorator/version'
require_relative 'lib/magic/decorator/authors'

Gem::Specification.new do |spec|
	spec.name        = 'magic-decorator'
	spec.version     = Magic::Decorator::VERSION
	spec.authors     = Magic::Decorator::AUTHORS.names
	spec.email       = Magic::Decorator::AUTHORS.emails
	spec.homepage    = "#{Magic::Decorator::AUTHORS.github_url}/#{spec.name}"
	spec.summary     = 'Decorators with some internal magic'
	spec.description = 'SimpleDelegator on steroids: automatic delegation, decorator class inference, etc.'
	spec.license     = 'MIT'

	spec.metadata['homepage_uri']    = spec.homepage
	spec.metadata['source_code_uri'] = spec.homepage
	spec.metadata['changelog_uri']   = "#{spec.metadata['source_code_uri']}/blob/v#{spec.version}/CHANGELOG.md"

	# Specify which files should be added to the gem when it is released.
	# The `git ls-files -z` loads the files in the RubyGem that have been added into git.
	gemspec = File.basename(__FILE__)
	spec.files = IO.popen(%w[git ls-files -z], chdir: __dir__, err: IO::NULL) do |ls|
		ls.readlines("\x0", chomp: true).reject do |f|
			(f == gemspec) ||
					f.start_with?(*%w[bin/ test/ spec/ features/ .git .github appveyor Gemfile])
		end
	end

	spec.required_ruby_version = '~> 3.2'

	spec.add_dependency 'magic-lookup'
end
