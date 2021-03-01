# frozen_string_literal: true

require_relative '../command'

module Ninny
  module Commands
    # A class to return the current dated branch
    class OutputDatedBranch < Ninny::Command
      attr_reader :branch_type

      def initialize(options)
        super
        @branch_type = options[:branch_type] || Git::STAGING_PREFIX
        @options = options
      end

      def execute(output: $stdout)
        output.puts Ninny.git.latest_branch_for(branch_type)
      end
    end
  end
end
