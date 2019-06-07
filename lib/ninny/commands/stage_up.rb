# frozen_string_literal: true

require_relative '../command'
require_relative 'pull_request_merge'

module Ninny
  module Commands
    class StageUp < PullRequestMerge
      def initialize(pull_request_id, options)
        super
        @branch_type = Ninny::Git::STAGING_PREFIX
      end
    end
  end
end
