module Ninny
  class UserConfig
    attr_reader :config

    def initialize
      @config = TTY::Config.new
      @config.filename = 'ninny'
      @config.extname = '.yml'
      @config.prepend_path Dir.home
      @config.append_path Dir.pwd
      @read = false
      @config.read
    end

    def write(*args)
      config.write(*args)
    end

    def set(*args)
      config.set(*args)
    end

    def repository_user
      fetch(:repository_user)
    end

    def repository_api_token
      fetch(:repository_api_token)
    end

    def repository
      fetch(:repository)
    end

    def self.config
      UserConfig.new
    end
  end
end
