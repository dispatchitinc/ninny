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

      def execute(output: $stdout)
        try_reading_user_config

        private_token = prompt_for_gitlab_private_token

        begin
          # TODO: This only works with thor gem < 2. So, we need to make this work when TTY
          #   releases versions compatible with thor >= 2 as well as < 2
          config.write(force: true)
        rescue StandardError
          puts '  Unable to update your ~/.ninny.yml file via TTY... continuing...'
          File.open("#{ENV['HOME']}/.ninny.yml", 'w') do |file|
            file.puts "gitlab_private_token: #{private_token}"
          end
        end

        output.puts "User config #{@result}!"
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
          new_token_text = ''
        end

        return unless prompt.yes?("Do you have a#{new_token_text} GitLab private token?")

        private_token = prompt.ask('Enter private token:', required: true)

        begin
          # TODO: This only works with thor gem < 2. So, we need to make this work when TTY
          #   releases versions compatible with thor >= 2 as well as < 2
          config.set(:gitlab_private_token, value: private_token)
        rescue ArgumentError
          puts '  Unable to set new token via TTY... continuing...'
        end

        private_token
      end
    end
  end
end
