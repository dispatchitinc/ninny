module Ninny
  class Git
    # branch prefixes
    DEPLOYABLE_PREFIX = "deployable"
    STAGING_PREFIX = "staging"
    QAREADY_PREFIX = "qaready"

    GIT = ::Git.open(Dir.pwd)
  end
end
