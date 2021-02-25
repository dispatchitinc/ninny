# frozen_string_literal: true


lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "ninny/version"

Gem::Specification.new do |spec|
  spec.name          = "ninny"
  spec.license       = "MIT"
  spec.version       = Ninny::VERSION
  spec.authors       = ["Carl Allen"]
  spec.email         = ["carl.allen@dispatchwithus.com"]

  spec.summary       = "ninny (n): an foolish person, see: git"
  spec.description   = "Ninny is a command line workflow for git"
  # spec.homepage      = "TODO: Put your gem's website or public repo URL here."

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  # if spec.respond_to?(:metadata)
  #   spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"

  #   spec.metadata["homepage_uri"] = spec.homepage
  #   spec.metadata["source_code_uri"] = "TODO: Put your gem's public repo URL here."
  #   spec.metadata["changelog_uri"] = "TODO: Put your gem's CHANGELOG.md URL here."
  # else
  #   raise "RubyGems 2.0 or newer is required to protect against " \
  #     "public gem pushes."
  # end

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "git", "~> 1.5.0"
  spec.add_dependency "gitlab", "~> 4.11"
  spec.add_dependency "pastel", "~> 0.7.2"
  spec.add_dependency "thor", "< 2"
  spec.add_dependency "tty-box", "~> 0.3.0"
  spec.add_dependency "tty-color", "~> 0.4"
  spec.add_dependency "tty-command", "~> 0.8.0"
  spec.add_dependency "tty-config", "~> 0.3.0"
  spec.add_dependency "tty-prompt", "~> 0.18.0"

  spec.add_development_dependency "bundler", "~> 1.17"
  spec.add_development_dependency "byebug"
  spec.add_development_dependency "guard-rspec", "~> 4.3"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
