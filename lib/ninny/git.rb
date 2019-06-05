module Ninny
  class Git
    # branch prefixes
    DEPLOYABLE_PREFIX = "deployable"
    STAGING_PREFIX = "staging"
    QAREADY_PREFIX = "qaready"

    GIT = ::Git.open(Dir.pwd)

    def self.new_branch(new_branch_name, source_branch_name)
      GIT.fetch
      GIT.branch("origin/#{source_branch_name}")
      GIT.branch(new_branch_name)
    end
  end
end
