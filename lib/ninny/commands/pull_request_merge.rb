# frozen_string_literal: true

require_relative '../command'

module Ninny
  module Commands
    # A class to merge a pull request
    class PullRequestMerge < Ninny::Command
      attr_accessor :pull_request_id, :options, :pull_request
      attr_reader :branch_type

      # rubocop:disable Lint/MissingSuper
      def initialize(pull_request_id, options)
        @branch_type = options[:branch_type] || Ninny::Git::STAGING_PREFIX
        self.pull_request_id = pull_request_id
        self.options = options
        self.pull_request = pull_request
      end
      # rubocop:enable Lint/MissingSuper

      def execute(*)
        unless pull_request_id
          current = Ninny.repo.current_pull_request
          self.pull_request_id = current.number if current
        end

        self.pull_request_id ||= select_pull_request

        check_out_branch
        merge_pull_request
        comment_about_merge
      end

      def select_pull_request
        choices = Ninny.repo.open_pull_requests.map { |pr| { name: pr.title, value: pr.number } }
        prompt.select("Which #{Ninny.repo.pull_request_label}?", choices)
      end
      private :select_pull_request

      # Public: Check out the branch
      def check_out_branch
        Ninny.git.check_out(branch_to_merge_into, false)
        Ninny.git.track_current_branch
      rescue Ninny::Git::NoBranchOfType
        prompt.say "No #{branch_type} branch available. Creating one now."
        CreateDatedBranch.new(branch: branch_type).execute
      end

      # Public: Merge the pull request's branch into the checked-out branch
      def merge_pull_request
        Ninny.git.merge(pull_request.branch)
      end

      # Public: Comment that the pull request was merged into the branch
      def comment_about_merge
        pull_request.write_comment(comment_body)
      end

      # Public: The content of the comment to post when merged
      #
      # Returns a String
      def comment_body
        "Merged into #{branch_to_merge_into}."
      end

      # Public: Find the pull request
      #
      # Returns a Ninny::Repository::PullRequest
      def pull_request
        @pull_request ||= Ninny.repo.pull_request(pull_request_id)
      end

      # Public: Find the branch
      #
      # Returns a String
      def branch_to_merge_into
        @branch_to_merge_into ||= Ninny.git.latest_branch_for(branch_type)
      end
    end
  end
end
