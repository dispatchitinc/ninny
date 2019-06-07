require 'ninny/commands/stage_up'

RSpec.describe Ninny::Commands::StageUp do
  it "executes `stage_up` command successfully" do
    output = StringIO.new
    pull_request_id = 1
    options = {}
    command = Ninny::Commands::StageUp.new(pull_request_id, options)

    expect(command).to receive(:check_out_branch)
    expect(command).to receive(:merge_pull_request)
    expect(command).to receive(:comment_about_merge)

    command.execute(output: output)
  end
end
