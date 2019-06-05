module Ninny
  class Git
    # branch prefixes
    DEPLOYABLE_PREFIX = "deployable"
    STAGING_PREFIX = "staging"
    QAREADY_PREFIX = "qaready"

    GIT = ::Git.open(Dir.pwd)

    def self.new_branch(new_branch_name, source_branch_name)
      GIT.fetch
      GIT.lib.command('branch', ['--no-track', new_branch_name, "origin/#{source_branch_name}"])
      branch = GIT.branch(new_branch_name)
      branch.checkout
      GIT.push('-u origin', branch)
    end
  end
end
