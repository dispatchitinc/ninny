require 'ninny/git'
require 'ninny/command'
require 'ninny/commands/create_dated_branch'
require 'ninny/commands/new_staging'
require 'ninny/commands/pull_request_merge'
require 'ninny/commands/setup'
require 'ninny/commands/stage_up'
require 'ninny/repository/gitlab'
require 'ninny/repository/pull_request'
require 'ninny/project_config'
require 'ninny/user_config'


require 'git'
require 'gitlab'
require 'tty-config'

module Ninny
  class Error < StandardError; end
  def self.project_config
    @config ||= ProjectConfig.config
  end

  def self.user_config
    @user_config ||= UserConfig.config
  end

  def self.repo
    @repo ||= project_config.repo
  end

  def self.git
    @git ||= Git.new
  end
end
