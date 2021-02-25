# Ninny

Ninny is a command line workflow for git with GitLab. It is maintained by the engineers of Dispatch.

We use Ninny to help us automate our development pipelines. We create weekly staging branches straight from `main`, merge feature branches into the current staging branch, and deploy to our staging environment directly from the current staging branch. We date all of our staging branches with `YYYY.MM.DD` appended to the end so that if we need to recreate a new staging branch mid-week (typically if the staging branch gets very out of date from `main`), then we know exactly which branch is the latest.

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

The private token should be a personal access token for that person's GitLab account (generated [here](https://gitlab.com/-/profile/personal_access_tokens)).

If that command doesn't work, then you can manually create/update that file like this:

```yml
gitlab_private_token: abc123def456ghi789jk # private token goes here
```

After the config files are set up, these commands are available:

```bash
# To create a new staging branch of this format: staging.YYYY.MM.DD
$ ninny new_staging

# To list the current/latest staging branch
$ ninny staging_branch

# To merge the current branch into the current/latest staging branch
$ ninny stage_up

```

At any point, `ninny help` will show the help screen.

## Development

### Making Changes

1. Clone or fork the repository
2. Create a feature branch for your changes
3. Run `bundle install`
4. Make your changes
5. Run `bundle exec rake` to run the tests
    * Run `bundle exec guard` to run tests continuously as you develop
6. Test the gem locally
    * Run `gem build *.gemspec` to build the gem locally
    * Run `gem install --local ninny-x.x.x.gem` to install the gem locally
7. Make a pull request back to this repository

### Releasing

1. Make sure the `lib/ninny/version.rb` file is updated with a new version
2. Run `git tag vX.X.X && git push --tag`
3. Run `gem build *.gemspec`
4. Run `gem push *.gem` to push the new version to RubyGems
5. Run `rm *.gem` to clean up your local repository

To set up your local machine to push to RubyGems via the API, see the [RubyGems documentation](https://guides.rubygems.org/publishing/#publishing-to-rubygemsorg).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/dispatchinc/ninny. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## Code of Conduct

Everyone interacting in the Ninny project’s codebases, issue trackers, chat rooms, and mailing lists is expected to follow the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## Copyright

Copyright (c) 2019 Dispatch. See [MIT License](LICENSE.txt) for further details.
