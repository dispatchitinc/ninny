module Ninny
  class Git
    # branch prefixes
    DEPLOYABLE_PREFIX = "deployable"
    STAGING_PREFIX = "staging"
    QAREADY_PREFIX = "qaready"

    attr_reader :git

    def initialize
      @git = ::Git.open(Dir.pwd)
    end

    def command(*args)
      git.lib.send(:command, *args)
    end

    def branch(*args)
      git.branch(*args)
    end

    def current_branch
      git.branch(git.current_branch)
    end

    def merge(branch_name)
      git.fetch
      current_branch.merge("origin/#{branch_name}")
    end

    # Public: Create a new branch from the given source
    #
    # new_branch_name - The name of the branch to create
    # source_branch_name - The name of the branch to branch from
    def new_branch(new_branch_name, source_branch_name)
      git.fetch
      command('branch', ['--no-track', new_branch_name, "origin/#{source_branch_name}"])
      branch = git.branch(new_branch_name)
      branch.checkout
      command('push', ['-u', 'origin', branch])
    end

    # Public: Delete the given branch
    #
    # branch_name - The name of the branch to delete
    def delete_branch(branch_name)
      branch = branch_name.is_a?(::Git::Branch) ? branch_name : git.branch(branch_name)
      git.push('origin', ":#{branch}")
      branch.delete
    end

    # Public: The list of branches on GitHub
    #
    # Returns an Array of Strings containing the branch names
    def remote_branches
      git.fetch
      git.branches.remote.map{ |branch| git.branch(branch.name) }.sort_by(&:name)
    end

    # Public: List of branches starting with the given string
    #
    # prefix - String to match branch names against
    #
    # Returns an Array of Branches containing the branch name
    def branches_for(prefix)
      remote_branches.select do |branch|
        branch.name =~ /^#{prefix}/
      end
    end

    # Public: Most recent branch starting with the given string
    #
    # prefix - String to match branch names against
    #
    # Returns an Array of Branches containing the branch name
    def latest_branch_for(prefix)
      branches_for(prefix).last || raise(NoBranchOfType, "No #{prefix} branch")
    end

    # Exceptions
    NotOnBranch = Class.new(StandardError)
    NoBranchOfType = Class.new(StandardError)
  end
end
