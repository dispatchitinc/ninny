# frozen_string_literal: true

# rubocop:disable Metrics/BlockLength

RSpec.describe Ninny::Git do
  subject { Ninny::Git.new }
  let(:git_lib) { double(:lib) }

  before do
    allow(git_lib).to receive(:command).with('status', '--short').and_return('')
    allow(subject.git).to receive(:lib).and_return(git_lib)
  end

  context '#branch' do
    it 'should call git.branch' do
      expect(subject.git).to receive(:branch)
      subject.branch
    end
  end

  context '#command' do
    it 'should call git.lib.command' do
      expect(git_lib).to receive(:command)
      subject.command
    end
  end

  context '#current_branch' do
    it 'should return current_branch from git' do
      expect(subject.git).to receive(:current_branch).at_least(:once).and_return('main')
      expect(subject.git).to receive(:branch).with('main')
      subject.current_branch
    end
  end

  context '#merge' do
    it 'should fetch and merge branch_name' do
      expect(subject.git).to receive(:fetch)
      expect(git_lib).to receive(:command).with('merge', ['--no-ff', 'origin/branch_to_merge'])
      expect(subject).to receive(:push)
      subject.merge('branch_to_merge')
    end
  end

  context '#new_branch' do
    it 'should fetch, create a new branch, checkout and push the new branch' do
      new_branch = double(:new_branch)
      expect(new_branch).to receive(:checkout)
      expect(subject.git).to receive(:fetch)
      expect(subject).to receive(:command).with('branch', ['--remote']).and_return('')
      expect(subject).to receive(:command).with('branch', ['--no-track', 'new_branch', 'origin/main'])
      expect(subject).to receive(:branch).with('new_branch').and_return(new_branch)
      expect(subject).to receive(:command).with('push', ['-u', 'origin', 'new_branch'])
      subject.new_branch('new_branch', 'main')
    end
  end

  context '#delete_branch' do
    let(:branch_to_delete) { double(:branch, is_a?: true, to_s: 'branch_to_delete') }
    it 'should delete remote and local branch with branch object' do
      expect(subject.git).to receive(:push).with('origin', ':branch_to_delete')
      expect(branch_to_delete).to receive(:delete)
      subject.delete_branch(branch_to_delete)
    end

    it 'should delete remote and local branch branch with string' do
      expect(subject.git).to receive(:branch).with('delety_branch').and_return(branch_to_delete)
      expect(subject.git).to receive(:push).with('origin', ':branch_to_delete')
      expect(branch_to_delete).to receive(:delete)
      subject.delete_branch('delety_branch')
    end
  end
end

# rubocop:enable Metrics/BlockLength
