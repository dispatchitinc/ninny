# frozen_string_literal: true

module Ninny
  module Commands
    class CreateDatedBranch < Ninny::Command
      attr_reader :branch_type, :should_delete_old_branches

      def initialize(options)
        @branch_type = options[:branch_type] || Git::STAGING_PREFIX
        @should_delete_old_branches = options[:delete_old_branches]
      end

      def execute(output: $stdout)
        create_branch
        delete_old_branches
        output.puts "#{branch_name} created"
        puts "hello"
        puts "hello"
        puts "hello"
        puts "hello"
        puts "hello"
        puts "hello"
        puts "hello"
        puts "hello"
        puts "hello"
        puts "hello"
        puts "hello"
        puts "hello"
        puts "hello"
        puts "hello"
        puts "hello"
        puts "hello"
        puts "hello"
        puts "hello"
        puts "hello"
        puts "hello"
        puts "hello"
        puts "hello"
        puts "hello"
        puts "hello"
        puts "hello"
        puts "hello"
        puts "hello"
        puts "hello"
        puts "hello"
      end

      # Public: Create the desired branch
      def create_branch
        Ninny.git.new_branch(branch_name, Ninny.project_config.deploy_branch)
      end

      # Public: The date suffix to append to the branch name
      def date_suffix
        Date.today.strftime('%Y.%m.%d')
      end

      # Public: The name of the branch to create
      def branch_name
        with_branch_type do
          "#{branch_type}.#{date_suffix}"
        end
      end

      # Public: If necessary, and if user opts to, delete old branches of its type
      def delete_old_branches
        return unless extra_branches.any?

        should_delete = should_delete_old_branches || prompt.yes?(
          "Do you want to delete the old #{branch_type} branch(es)? (#{extra_branches.join(', ')})"
        )

        return unless should_delete

        extra_branches.each do |extra|
          Ninny.git.delete_branch(extra)
        end
      end

      # Public: The list of extra branches that exist after creating the new branch
      #
      # Returns an Array of Strings of the branch names
      def extra_branches
        with_branch_type do
          Ninny.git.branches_for(branch_type).reject { |branch| branch.name == branch_name }
        end
      end

      def with_branch_type
        case branch_type
        when Git::DEPLOYABLE_PREFIX, Git::STAGING_PREFIX, Git::QAREADY_PREFIX
          yield
        else
          raise InvalidBranchType, "'#{branch_type}' is not a valid branch type"
        end
      end
    end
  end
  InvalidBranchType = Class.new(StandardError)
end
