module Ninny
  class UserConfig
    attr_reader :config

    def initialize
      @config = TTY::Config.new
      @config.filename = '.ninny'
      @config.extname = '.yml'
      @config.prepend_path Dir.home
      @config.read
    end

    def write(*args)
      config.write(*args)
    end

    def set(*args)
      config.set(*args)
    end

    def gitlab_private_token
      config.fetch(:gitlab_private_token)
    end

    def self.config
      new
    end
  end
end
