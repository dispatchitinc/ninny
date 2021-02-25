# Ninny

Ninny is a command line workflow for git with GitLab. It is maintained by the engineers of Dispatch, Inc.

We use Ninny to help us automate our developmen pipelines. We create weekly staging branches straight from `main`, merge feature branches into the current staging branch, and deploy to our staging environment directly from the current staging branch. We date all of our staging branches with `YYYY.MM.DD` appended to the end so that if we need to recreate a new staging branch mid-week (typically if the staging branch gets very out of date from `main`), then we know exactly which branch is the latest.

Ninny is based off of [SportsEngine's Octopolo](https://github.com/sportngin/octopolo) command-line tool.

## Installation

To use this gem with an application on GitLab, add this line to your project's Gemfile:

```ruby
gem 'ninny'
```

And then execute:

```bash
$ bundle install
```

Then, you'll need to install the gem on your local computer:

```bash
$ gem install ninny
```

## Usage

To use this gem with a GitLab project, you'll need to add the following information in a `.ninny.yml` file in the root directory of the project:

```yml
repo_type: gitlab
gitlab_project_id: GITLAB_PROJECT_ID
deploy_branch: DEPLOY_BRANCH
```

The `GITLAB_PROJECT_ID` can be found in the general settings of the entire project. The `DEPLOY_BRANCH` is most likely your project's default branch.

Then, each developer on the project should set up a file at `~/.ninny.yml` on their computer. To help with this, they can run the following and follow the prompts:

```bash
$ ninny setup
Do you have a new gitlab private token? (Y/n) y # enter 'y'
Enter private token abc123def456ghi789jk # enter your private token
User config updated
```

If that command doesn't work, then you can manually update that file like this:

```yml
gitlab_private_token: abc123def456ghi789jk # private token goes here
```

After the config files are set up, there are the commands available:

```bash
$ ninny new_staging # to create a new staging branch of this format: staging.YYYY.MM.DD
$ ninny staging_branch # to list the current/latest staging branch
$ ninny stage_up # to merge the current branch into the current/latest staging branch
```

At any point, `ninny help` will show the help screen.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/dispatchinc/ninny. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## Code of Conduct

Everyone interacting in the Ninny project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## Copyright

Copyright (c) 2019 Dispatch, Inc. See [MIT License](LICENSE.txt) for further details.
