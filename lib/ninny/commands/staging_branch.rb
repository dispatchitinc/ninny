# frozen_string_literal: true

require_relative '../command'

module Ninny
  module Commands
    class StagingBranch < OutputDatedBranch
      def initialize(options)
        super
        @branch_type = Git::STAGING_PREFIX
      end
    end
  end
end
