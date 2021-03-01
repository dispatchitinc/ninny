# frozen_string_literal: true

module Ninny
  # The project configuration
  class ProjectConfig
    attr_reader :config

    def initialize
      @config = TTY::Config.new
      @config.filename = '.ninny'
      @config.extname = '.yml'
      @config.prepend_path Dir.pwd
      @config.read
    end

    def write(*args)
      config.write(*args)
    end

    def set(*args)
      config.set(*args)
    end

    def repo_type
      config.fetch(:repo_type)
    end

    def deploy_branch
      config.fetch(:deploy_branch)
    end

    def gitlab_project_id
      config.fetch(:gitlab_project_id)
    end

    def gitlab_endpoint
      config.fetch(:gitlab_endpoint, default: 'https://gitlab.com/api/v4')
    end

    def repo
      return unless repo_type

      repo_class = { gitlab: Repository::Gitlab }[repo_type.to_sym]
      repo_class&.new
    end

    def self.config
      new
    end
  end
end
