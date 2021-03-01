# frozen_string_literal: true

module Ninny
  module Repository
    # The GitLab client object
    class Gitlab
      attr_reader :gitlab, :project_id

      def initialize
        @gitlab = ::Gitlab.client(
          endpoint: Ninny.project_config.gitlab_endpoint,
          private_token: Ninny.user_config.gitlab_private_token
        )
        @project_id = Ninny.project_config.gitlab_project_id
      end

      def current_pull_request
        to_pr(
          gitlab.merge_requests(
            project_id,
            { source_branch: Ninny.git.current_branch.name, target_branch: Ninny.project_config.deploy_branch }
          ).last
        )
      end

      def pull_request_label
        'Merge Request'
      end

      def open_pull_requests
        gitlab.merge_requests(project_id, { state: 'opened' }).map { |mr| to_pr(mr) }
      end

      def pull_request(id)
        to_pr(gitlab.merge_request(project_id, id))
      end

      def create_merge_request_note(id, body)
        gitlab.create_merge_request_note(project_id, id, body)
      end

      def to_pr(request)
        request && PullRequest.new(
          number: request.iid,
          title: request.title,
          branch: request.source_branch,
          description: request.description,
          comment_lambda: ->(body) { Ninny.repo.create_merge_request_note(request.iid, body) }
        )
      end
      private_class_method :to_pr
    end
  end
end
