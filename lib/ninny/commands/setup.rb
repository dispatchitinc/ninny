# frozen_string_literal: true

require_relative '../command'

module Ninny
  module Commands
    # A command to set up the ninny config file
    class Setup < Ninny::Command
      attr_reader :config

      def initialize(options)
        super
        @options = options
        @config = Ninny.user_config
      end

      def execute(output: $stdout)
        try_reading_user_config

        prompt_for_gitlab_private_token

        config.write(force: true)
        # Command logic goes here ...
        output.puts "User config #{@result}"
      end

      def try_reading_user_config
        config.read
        @result = 'updated'
      rescue MissingUserConfig
        @result = 'created'
      end

      def prompt_for_gitlab_private_token
        begin
          new_token_text = config.gitlab_private_token ? ' new' : ''
        rescue MissingUserConfig
          new_token_text = 'new'
        end

        return unless prompt.yes?("Do you have a#{new_token_text} gitlab private token?")

        private_token = prompt.ask('Enter private token', required: true)
        config.set(:gitlab_private_token, value: private_token)
      end
    end
  end
end
