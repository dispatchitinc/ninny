# frozen_string_literal: true

require_relative '../command'
require_relative "../dated_branch_creator"
require_relative "../git"

module Ninny
  module Commands
    class NewStaging < Ninny::Command
      def initialize(options)
        @options = options
      end

      def execute(input: $stdin, output: $stdout)
        Ninny::DatedBranchCreator.perform(Git::STAGING_PREFIX, @options[:delete_old_branches])
      end
    end
  end
end
