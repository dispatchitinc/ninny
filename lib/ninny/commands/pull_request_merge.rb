# frozen_string_literal: true

require_relative '../command'

module Ninny
  module Commands
    class PullRequestMerge < Ninny::Command
      attr_accessor :pull_request_id, :options, :pull_request
      attr_reader :branch_type, :username

      def initialize(pull_request_id, options)
        @branch_type = options[:branch_type] || Ninny::Git::STAGING_PREFIX
        self.pull_request_id = pull_request_id
        self.options = options
      end

      def execute(*)
        unless pull_request_id
          current = Ninny.repo.current_pull_request
          self.pull_request_id = current.number if current
        end

        self.pull_request_id ||= select_pull_request

        return nil if pull_request_id.nil?

        check_out_branch
        merge_pull_request
        comment_about_merge
      end

      def select_pull_request
        choices = Ninny.repo.open_pull_requests.map { |pr| { name: pr.title, value: pr.number } }

        if choices.empty?
          prompt.say "There don't seem to be any open merge requests."
        else
          prompt.select("Which #{Ninny.repo.pull_request_label}?", choices)
        end
      end
      private :select_pull_request

      # Public: Check out the branch
      def check_out_branch
        prompt.say "Checking out #{branch_to_merge_into}."
        Ninny.git.check_out(branch_to_merge_into, false)
        Ninny.git.track_current_branch
      rescue Ninny::Git::NoBranchOfType
        prompt.say "No #{branch_type} branch available. Creating one now."
        CreateDatedBranch.new(branch: branch_type).execute
      end

      # Public: Merge the pull request's branch into the checked-out branch
      def merge_pull_request
        prompt.say "Merging #{pull_request.branch} to #{branch_to_merge_into}."
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
        user = username || determine_local_user
        body = "Merged into #{branch_to_merge_into}"
        body << " by #{user}" if user
        body << '.'
      end

      # Public: Find the pull request
      #
      # Returns a Ninny::Repository::PullRequest
      # rubocop:disable Lint/DuplicateMethods
      def pull_request
        @pull_request ||= Ninny.repo.pull_request(pull_request_id)
      end
      # rubocop:enable Lint/DuplicateMethods

      # Public: Find the branch
      #
      # Returns a String
      def branch_to_merge_into
        @branch_to_merge_into ||= Ninny.git.latest_branch_for(branch_type)
      end

      def determine_local_user
        local_user_name = `git config user.name`.strip
        local_user_name.empty? ? nil : local_user_name
      end
    end
  end
end
