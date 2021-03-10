# frozen_string_literal: true

require 'thor'

module Ninny
  # Handle the application command line parsing
  # and the dispatch to various command objects
  #
  # @api public
  class CLI < Thor
    # Error raised by this runner
    Error = Class.new(StandardError)

    desc 'version', 'ninny version'
    def version
      require_relative 'version'
      puts "v#{Ninny::VERSION}"
    end
    map %w[--version -v] => :version

    desc 'staging_branch', 'Returns the current staging branch'
    method_option :help, aliases: '-h', type: :boolean, desc: 'Display usage information'
    def staging_branch(*)
      if options[:help]
        invoke :help, ['staging_branch']
      else
        require_relative 'commands/staging_branch'
        Ninny::Commands::StagingBranch.new(options).execute
      end
    end

    desc 'stage_up [PULL_REQUEST_ID]', 'Merges PR/MR into the staging branch'
    method_option :help, aliases: '-h', type: :boolean, desc: 'Display usage information'
    def stage_up(pull_request_id = nil)
      if options[:help]
        invoke :help, ['stage_up']
      else
        require_relative 'commands/stage_up'
        Ninny::Commands::StageUp.new(pull_request_id, options).execute
      end
    end

    desc 'new_staging', 'Create a new staging branch'
    method_option :help, aliases: '-h', type: :boolean, desc: 'Display usage information'
    method_option :delete_old_branches, aliases: ['-d'], type: :boolean, desc: 'Should old staging branches be deleted?'
    def new_staging(*)
      if options[:help]
        invoke :help, ['new_staging']
      else
        require_relative 'commands/new_staging'
        Ninny::Commands::NewStaging.new(options).execute
      end
    end

    desc 'setup', 'Interactively setup configuration'
    method_option :help, aliases: '-h', type: :boolean, desc: 'Display usage information'
    method_option :token, aliases: '-t', type: :string, desc: 'The GitLab token to add to the ~/.ninny.yml file'
    def setup(*)
      if options[:help]
        invoke :help, ['setup']
      else
        require_relative 'commands/setup'
        Ninny::Commands::Setup.new(options).execute
      end
    end
  end
end
