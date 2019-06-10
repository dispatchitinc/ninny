# frozen_string_literal: true

require_relative '../command'

module Ninny
  module Commands
    class Setup < Ninny::Command
      attr_reader :config
      def initialize(options)
        @options = options
        @config = Ninny.user_config
      end

      def execute(input: $stdin, output: $stdout)
        try_reading_user_config

        prompt_for_gitlab_private_token

        config.write(force: true)
        # Command logic goes here ...
        output.puts "User config #{@result}"
      end

      def try_reading_user_config
        begin
          config.read
          @result = 'updated'
        rescue MissingUserConfig
          @result = 'created'
        end
      end

      def prompt_for_gitlab_private_token
        new_token_text = config.gitlab_private_token ? ' new' : ''
        if prompt.yes?("Do you have a#{new_token_text} gitlab private token?")
          private_token = prompt.ask("Enter private token", required: true)
          config.set(:gitlab_private_token, value: private_token)
        end
      end
    end
  end
end
