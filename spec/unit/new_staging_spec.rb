require 'ninny/commands/new_staging'

RSpec.describe Ninny::Commands::NewStaging do
  it "executes `new_staging` command successfully" do
    output = StringIO.new
    options = {}
    command = Ninny::Commands::NewStaging.new(options)

    command.execute(output: output)

    expect(output.string).to eq("OK\n")
  end
end
