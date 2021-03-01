# frozen_string_literal: true

module Ninny
  module Commands
    class NewStaging < CreateDatedBranch
      def initialize(options)
        super
        @branch_type = Git::STAGING_PREFIX
        puts "Hello"
      end
    end
  end
end
