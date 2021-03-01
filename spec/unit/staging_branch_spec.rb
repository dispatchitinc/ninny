# frozen_string_literal: true

require 'ninny/commands/staging_branch'

RSpec.describe Ninny::Commands::StagingBranch do
  subject { Ninny::Commands::StagingBranch.new({}) }
  it 'executes `staging_branch` command successfully' do
    expect(Ninny.git).to receive(:latest_branch_for).with('staging').and_return('staging.2019.09.16')
    output = StringIO.new

    subject.execute(output: output)

    expect(output.string).to eq("staging.2019.09.16\n")
  end
end
