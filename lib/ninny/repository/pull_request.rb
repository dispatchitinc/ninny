module Ninny
  module Repository
    class PullRequest
      attr_accessor :number, :title, :description, :branch, :comment_lambda
      def initialize(opts={})
        self.number = opts[:number]
        self.title = opts[:title]
        self.description = opts[:description]
        self.branch = opts[:branch]
        self.comment_lambda = opts[:comment_lambda]
      end

      def write_comment(body)
        self.comment_lambda.call(body)
      end
    end
  end
end
