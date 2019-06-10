require "bundler/setup"
require 'byebug'
require "ninny"
require 'tty-config'

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end

class GitStub
end

module Git
  def self.open(*args)
    GitStub.new
  end
end

class GitlabStub
end

module Gitlab
  def self.client(*args)
    GitlabStub.new
  end
end

module Ninny
  def self.repo
    @repo ||= GitlabStub.new
  end
end

class TTY::Config
  def write(*args)
  end
end
