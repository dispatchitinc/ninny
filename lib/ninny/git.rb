require 'git'

module Ninny
  class Git
    # branch prefixes
    DEPLOYABLE_PREFIX = "deployable"
    STAGING_PREFIX = "staging"
    QAREADY_PREFIX = "qaready"

    GIT = ::Git.open(Dir.pwd)

    def self.command(*args)
      GIT.lib.send(:command, *args)
    end

    def self.branch(*args)
      GIT.branch(*args)
    end

    # Public: Create a new branch from the given source
    #
    # new_branch_name - The name of the branch to create
    # source_branch_name - The name of the branch to branch from
    #
    # Example:
    #
    #   Git.new_branch("bug-123-fix-thing", "master")
    def self.new_branch(new_branch_name, source_branch_name)
      GIT.fetch
      command('branch', ['--no-track', new_branch_name, "origin/#{source_branch_name}"])
      branch = GIT.branch(new_branch_name)
      branch.checkout
      command('push', ['-u', 'origin', branch])
    end

    # Public: Delete the given branch
    #
    # branch_name - The name of the branch to delete
    def self.delete_branch(branch_name)
      branch = branch_name.is_a?(::Git::Branch) ? branch_name : GIT.branch(branch_name)
      GIT.push('origin', ":#{branch}")
      branch.delete
    end

    # Public: The list of branches on GitHub
    #
    # Returns an Array of Strings containing the branch names
    def self.remote_branches
      GIT.fetch
      GIT.branches.remote.map{ |branch| GIT.branch(branch.name) }
    end

    # Public: List of branches starting with the given string
    #
    # prefix - String to match branch names against
    #
    # Returns an Array of Branches containing the branch name
    def self.branches_for(prefix)
      remote_branches.select do |branch|
        branch.name =~ /^#{prefix}/
      end
    end
  end
end
