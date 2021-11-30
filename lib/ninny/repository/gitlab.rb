# frozen_string_literal: true

module Ninny
  module Repository
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
          all_merge_requests(
            project_id,
            {
              source_branch: Ninny.git.current_branch.name,
              target_branch: Ninny.project_config.deploy_branch,
              state: 'opened'
            }
          ).last
        )
      end

      def pull_request_label
        'Merge Request'
      end

      def open_pull_requests
        all_merge_requests(project_id, { state: 'opened' }).map { |mr| to_pr(mr) }
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
      private :to_pr

      def all_merge_requests(project_id, params)
        page_number = 1
        counter = 1
        merge_requests = []

        while counter.positive?
          page_merge_requests = gitlab.merge_requests(project_id, params.merge(page: page_number, per_page: 100))
          merge_requests.concat(page_merge_requests)
          counter = page_merge_requests.count
          page_number += 1
        end

        merge_requests
      end
      private :all_merge_requests
    end
  end
end
