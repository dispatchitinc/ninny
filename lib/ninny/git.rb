require 'git'

module Ninny
  class Git
    # branch prefixes
    DEPLOYABLE_PREFIX = "deployable"
    STAGING_PREFIX = "staging"
    QAREADY_PREFIX = "qaready"

    GIT = ::Git.open(Dir.pwd)

    def self.new_branch(new_branch_name, source_branch_name)
      GIT.fetch
      command('branch', ['--no-track', new_branch_name, "origin/#{source_branch_name}"])
      branch = GIT.branch(new_branch_name)
      branch.checkout
      command('push', ['-u', 'origin', branch])
    end

    def self.command(*args)
      GIT.lib.send(:command, *args)
    end
  end
end
