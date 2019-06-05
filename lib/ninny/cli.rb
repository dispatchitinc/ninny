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
    map %w(--version -v) => :version

    desc 'new_staging', 'Command description...'
    method_option :help, aliases: '-h', type: :boolean,
                         desc: 'Display usage information'
    method_option :delete_old_branches, aliases: ['-d'], type: :boolean,
                                        desc: "Should old staging branches be deleted?"

    def new_staging(*)
      if options[:help]
        invoke :help, ['new_staging']
      else
        require_relative 'commands/new_staging'
        Ninny::Commands::NewStaging.new(options).execute
      end
    end

    desc 'setup', 'Interactively setup configuration'
    method_option :help, aliases: '-h', type: :boolean,
                         desc: 'Display usage information'
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
