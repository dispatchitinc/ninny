# frozen_string_literal: true

module Ninny
  # The user configuration
  class UserConfig
    attr_reader :config

    def initialize
      @config = TTY::Config.new
      @config.filename = '.ninny'
      @config.extname = '.yml'
      @config.prepend_path Dir.home
      @read = false
    end

    def write(*args)
      config.write(*args)
    end

    def set(*args)
      config.set(*args)
    end

    def gitlab_private_token
      with_read do
        config.fetch(:gitlab_private_token)
      end
    end

    def read
      config.read unless @read
    rescue TTY::Config::ReadError
      raise MissingUserConfig, 'User config not found, run `ninny setup`'
    end

    def with_read
      read
      @read = true
      yield
    end

    def self.config
      new
    end
  end

  MissingUserConfig = Class.new(StandardError)
end
