# frozen_string_literal: true

require_relative '../command'

module Ninny
  module Commands
    class Setup < Ninny::Command
      attr_reader :config, :private_token

      def initialize(options)
        @options = options
        @private_token = options[:token]
        @config = Ninny.user_config
      end

      def execute(output: $stdout)
        try_reading_user_config

        unless private_token
          private_token = prompt_for_gitlab_private_token

          unless private_token
            output.puts "Please create a private token on GitLab and then rerun 'ninny setup'."
            return
          end

          config_set_gitlab_private_token(private_token)
        end

        write_gitlab_private_token(private_token)
        output.puts "User config #{@result}!"
      end

      def try_reading_user_config
        config.read
        @result = 'updated'
      rescue MissingUserConfig
        @result = 'created'
      end

      def config_set_gitlab_private_token(private_token)
        # TODO: This only works with thor gem < 1. So, we need to make this work when TTY
        #   releases versions compatible with thor versions >= 1 as well.
        config.set(:gitlab_private_token, value: private_token)
      rescue ArgumentError
        puts '  Unable to set new token via TTY... continuing anyway...'
      end

      def write_gitlab_private_token(private_token)
        # TODO: This only works with thor gem < 1. So, we need to make this work when TTY
        #   releases versions compatible with thor versions >= 1 as well.
        config.write(force: true)
      rescue StandardError
        puts '  Unable to write config file via TTY... continuing anyway...'
        File.open("#{ENV['HOME']}/.ninny.yml", 'w') { |file| file.puts "gitlab_private_token: #{private_token}" }
      end

      def prompt_for_gitlab_private_token
        begin
          new_token_text = config.gitlab_private_token ? ' new' : ''
        rescue MissingUserConfig
          new_token_text = ''
        end

        return unless prompt.yes?("Do you have a#{new_token_text} GitLab private token?")

        prompt.ask('Enter private token:', required: true)
      end
    end
  end
end
