# frozen_string_literal: true

require 'ninny/commands/stage_up'
require 'tty-prompt'

RSpec.describe Ninny::Commands::PullRequestMerge do
  let(:branch_type) { Ninny::Git::STAGING_PREFIX }
  subject { Ninny::Commands::PullRequestMerge.new(1, {}) }

  it 'executes `stage_up` command successfully' do
    output = StringIO.new

    expect(subject).to receive(:check_out_branch)
    expect(subject).to receive(:merge_pull_request)
    expect(subject).to receive(:comment_about_merge)

    subject.execute(output: output)
  end

  context 'when there are no open pull requests' do
    subject { Ninny::Commands::PullRequestMerge.new(nil, {}) }

    it 'does not attempt to merge' do
      output = StringIO.new

      allow(Ninny.repo).to receive(:current_pull_request).and_return(nil)
      allow(subject).to receive(:select_pull_request).and_return(nil)
      expect(subject).not_to receive(:check_out_branch)
      subject.execute(output: output)
    end
  end

  context '#check_out_branch' do
    it 'should check out the branch to merge into' do
      branch = double(:branch)
      allow(Ninny.git).to receive(:latest_branch_for).and_return(branch)
      expect(Ninny.git).to receive(:check_out).with(branch, false)
      allow(Ninny.git).to receive(:current_branch_name).and_return('branch')
      allow(Ninny.git).to receive(:command).and_return([])
      subject.check_out_branch
    end

    it 'should end if there is no branch' do
      allow(Ninny.git).to receive(:branches_for).and_return([])
      expect_any_instance_of(TTY::Prompt).to receive(:say).with(
        'Could not find a staging branch. Please create one or double check it exists. If it exists, ' \
        'please do a fresh git pull or git fetch to ensure Ninny can find it.'
      )
      subject.check_out_branch
    end
  end

  context '#merge_pull_request' do
    it 'should call merge between the branches' do
      allow_any_instance_of(TTY::Prompt).to receive(:say).with('Merging pr_branch_name to staging-branch.')
      allow(subject).to receive(:branch_to_merge_into).and_return('staging-branch')
      pr = double(:pull_request, branch: 'pr_branch_name')
      allow(subject).to receive(:pull_request).and_return(pr)
      expect(Ninny.git).to receive(:merge).with('pr_branch_name')
      subject.merge_pull_request
    end
  end

  context '#comment_about_merge' do
    context 'when no user name is passed in' do
      it 'should comment to the pull_request' do
        pr = double(:pull_request)
        allow(subject).to receive(:branch_to_merge_into).and_return('staging')
        allow(subject).to receive(:pull_request).and_return(pr)
        allow(subject).to receive(:`).with('git config user.name').and_return('Test User')
        expect(pr).to receive(:write_comment).with('Merged into staging by Test User.')
        subject.comment_about_merge
      end
    end

    context 'when a user name is passed in' do
      it 'should comment to the pull_request' do
        pr = double(:pull_request)
        allow(subject).to receive(:branch_to_merge_into).and_return('staging')
        allow(subject).to receive(:pull_request).and_return(pr)
        allow(subject).to receive(:username).and_return('Given User')
        expect(subject).not_to receive(:`).with('git config user.name')
        expect(pr).to receive(:write_comment).with('Merged into staging by Given User.')
        subject.comment_about_merge
      end
    end
  end

  context '#pull_request' do
    it 'should call repo pull_request for pull_request_id' do
      expect(Ninny.repo).to receive(:pull_request).with(1)
      subject.pull_request
    end
  end

  context '#branch_to_merge_into' do
    it 'should call repo pull_request for pull_request_id' do
      expect(Ninny.git).to receive(:latest_branch_for).with(branch_type)
      subject.branch_to_merge_into
    end
  end
end
