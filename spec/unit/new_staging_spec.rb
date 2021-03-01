# frozen_string_literal: true

require 'tty-prompt'

# rubocop:disable Metrics/BlockLength

RSpec.describe Ninny::Commands::NewStaging do
  subject { Ninny::Commands::NewStaging.new(delete_old_branches: true) }

  before do
    allow_any_instance_of(Date).to receive(:strftime).with('%Y.%m.%d').and_return('2019.09.16')
  end

  it 'executes `new_staging` command successfully' do
    expect(subject).to receive(:create_branch)
    expect(subject).to receive(:delete_old_branches)

    output = StringIO.new
    subject.execute(output: output)

    expect(output.string).to eq("staging.2019.09.16 created\n")
  end

  context '#create_branch' do
    it 'should create new branch' do
      allow(Ninny).to receive(:project_config).and_return(double(:config, deploy_branch: 'mainx'))
      expect(subject).to receive(:branch_name).and_return('staging.2019.09.16')
      expect(Ninny.git).to receive(:new_branch).with('staging.2019.09.16', 'mainx')
      subject.create_branch
    end
  end

  context '#branch_name' do
    it 'should return branch name based on date' do
      allow(subject).to receive(:branch_type).and_return('deployable')
      allow_any_instance_of(Date).to receive(:strftime).with('%Y.%m.%d').and_return('2019.09.15')
      expect(subject.branch_name).to eq('deployable.2019.09.15')
    end

    it 'should throw exception with invalid branch type' do
      allow(subject).to receive(:branch_type).and_return('crushable')
      expect { subject.branch_name }.to raise_error(Ninny::InvalidBranchType)
    end
  end

  context '#delete_old_branches' do
    it 'should do nothing if extra_branches is empty' do
      allow(subject).to receive(:extra_branches).and_return([])
      expect(subject.delete_old_branches).to be_nil
    end

    context 'with old branches' do
      let(:branch_one) { double(:branch_one) }
      let(:branch_two) { double(:branch_two) }
      before { allow(subject).to receive(:extra_branches).and_return([branch_one, branch_two]) }

      it 'should delete old branches if flag is set' do
        expect(Ninny.git).to receive(:delete_branch).with(branch_one)
        expect(Ninny.git).to receive(:delete_branch).with(branch_two)
        subject.delete_old_branches
      end

      it 'should prompt for deletion if flag is not set' do
        allow(subject).to receive(:should_delete_old_branches).and_return(false)
        expect(Ninny.git).to receive(:delete_branch).with(branch_one)
        expect(Ninny.git).to receive(:delete_branch).with(branch_two)
        expect_any_instance_of(TTY::Prompt).to receive(:yes?).with(
          /Do you want to delete the old staging branch(es)?/
        ).and_return(true)
        subject.delete_old_branches
      end
    end
  end

  context '#extra_branches' do
    let(:branch_one) { double(:branch_one, name: 'staging.2019.09.16') }
    let(:branch_two) { double(:branch_two, name: 'staging.2019.09.15') }
    before { expect(Ninny.git).to receive(:branches_for).with('staging').and_return([branch_one, branch_two]) }
    it 'should fetch extra branches from git' do
      expect(subject.extra_branches).to eq([branch_two])
    end
  end
end

# rubocop:enable Metrics/BlockLength
