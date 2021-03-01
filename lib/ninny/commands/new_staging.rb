# frozen_string_literal: true

module Ninny
  module Commands
    # A class to specifically create a new staging branch with a datestamp
    class NewStaging < CreateDatedBranch
      def initialize(options)
        super
        @branch_type = Git::STAGING_PREFIX
      end
    end
  end
end
