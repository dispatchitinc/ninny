# frozen_string_literal: true

module Ninny
  # rubocop:disable Metrics/ClassLength
  class Git
    extend Forwardable
    NO_BRANCH = '(no branch)'
    DEFAULT_DIRTY_MESSAGE = 'Your Git index is not clean. Commit, stash, or otherwise clean' \
                            ' up the index before continuing.'
    DIRTY_CONFIRM_MESSAGE = 'Your Git index is not clean. Do you want to continue?'

    # branch prefixes
    DEPLOYABLE_PREFIX = 'deployable'
    STAGING_PREFIX = 'staging'
    QAREADY_PREFIX = 'qaready'

    def_delegators :git, :branch

    attr_reader :git

    def initialize
      @git = ::Git.open(Dir.pwd)
    end

    def command(*args)
      git.lib.send(:command, *args)
    end

    def current_branch
      git.branch(current_branch_name)
    end

    def current_branch_name
      raise NotOnBranch, 'Not currently checked out to a particular branch' if git.current_branch == NO_BRANCH

      git.current_branch
    end

    def merge(branch_name)
      if_clean do
        `git fetch --prune &> /dev/null`
        command('merge', '--no-ff', "origin/#{branch_name}")
        raise MergeFailed unless clean?

        push
      end
    end

    # Public: Push the current branch to GitHub
    def push
      if_clean do
        git.push('origin', current_branch_name)
      end
    end

    # Public: Pull the latest changes for the checked-out branch
    def pull
      if_clean do
        command('pull')
      end
    end

    # Public: Check out the given branch name
    #
    # branch_name - The name of the branch to check out
    # do_after_pull - Should a pull be done after checkout?
    def check_out(branch, do_after_pull = true)
      `git fetch --prune &> /dev/null`
      git.checkout(branch)
      pull if do_after_pull
      raise CheckoutFailed, "Failed to check out '#{branch}'" unless current_branch.name == branch.name
    end

    # Public: Track remote branch matching current branch
    #
    # do_after_pull - Should a pull be done after tracking?
    def track_current_branch(do_after_pull = true)
      command('branch', '-u', "origin/#{current_branch_name}")
      pull if do_after_pull
    end

    # Public: Create a new branch from the given source
    #
    # new_branch_name - The name of the branch to create
    # source_branch_name - The name of the branch to branch from
    def new_branch(new_branch_name, source_branch_name)
      `git fetch --prune &> /dev/null`
      remote_branches = command('branch', '--remote')

      if remote_branches.include?("origin/#{new_branch_name}")
        ask_to_recreate_branch(new_branch_name, source_branch_name)
      else
        create_branch(new_branch_name, source_branch_name)
      end
    rescue ::Git::GitExecuteError => e
      if e.message.include?(':fatal: A branch named') && e.message.include?(' already exists')
        puts "The local branch #{new_branch_name} already exists." \
             ' Please delete it manually and then run this command again.'
        exit 1
      end
    end

    # Public: Delete the given branch
    #
    # branch_name - The name of the branch to delete
    def delete_branch(branch_name)
      branch = branch_name.is_a?(::Git::Branch) ? branch_name : git.branch(branch_name)
      git.push('origin', ":#{branch}")
      branch.delete
    rescue ::Git::GitExecuteError => e
      if e.message.include?(':error: branch') && e.message.include?(' not found.')
        puts 'Could not delete local branch, but the remote branch was deleted.'
      end
    end

    # Public: The list of branches on GitHub
    #
    # Returns an Array of Strings containing the branch names
    def remote_branches
      `git fetch --prune &> /dev/null`
      git.branches.remote.map { |branch| git.branch(branch.name) }.sort_by(&:name)
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
      # I don't really see why the first part would break, and the second would work, but you never know
      branches_for(prefix).last || Ninny.git.branches_for(prefix).last || raise(NoBranchOfType, "No #{prefix} branch")
    end

    # Public: Whether the Git index is clean (has no uncommited changes)
    #
    # Returns a Boolean
    def clean?
      command('status', '--short').empty?
    end

    # Public: Perform the block if the Git index is clean
    def if_clean(message = DEFAULT_DIRTY_MESSAGE)
      if clean? || prompt.yes?(DIRTY_CONFIRM_MESSAGE)
        yield
      else
        alert_dirty_index message
        exit 1
      end
    end

    # Public: Display the message and show the git status
    def alert_dirty_index(message)
      prompt.say ' '
      prompt.say message
      prompt.say ' '
      prompt.say command('status')
      raise DirtyIndex
    end

    def prompt(**options)
      require 'tty-prompt'
      TTY::Prompt.new(*options)
    end

    # Private: Ask the user if they wish to delete and recreate a branch
    #
    # new_branch_name: the name of the branch in question
    # source_branch_name: the name of the branch the new branch is supposed to be based off of
    private def ask_to_recreate_branch(new_branch_name, source_branch_name)
      if prompt.yes?("The branch #{new_branch_name} already exists. Do you wish to delete and recreate?")
        delete_branch(new_branch_name)
        new_branch(new_branch_name, source_branch_name)
      else
        exit 1
      end
    end

    # Private: Create a branch
    #
    # new_branch_name: the name of the branch in question
    # source_branch_name: the name of the branch the new branch is supposed to be based off of
    private def create_branch(new_branch_name, source_branch_name)
      command('branch', '--no-track', new_branch_name, "origin/#{source_branch_name}")
      new_branch = branch(new_branch_name)
      new_branch.checkout
      command('push', '-u', 'origin', new_branch_name)
    end

    # Exceptions
    CheckoutFailed = Class.new(StandardError)
    NotOnBranch = Class.new(StandardError)
    NoBranchOfType = Class.new(StandardError)
    DirtyIndex = Class.new(StandardError)
  end
  # rubocop:enable Metrics/ClassLength
end
