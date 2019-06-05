require 'ninny/commands/setup'

RSpec.describe Ninny::Commands::Setup do
  it "executes `setup` command successfully" do
    output = StringIO.new
    options = {}
    command = Ninny::Commands::Setup.new(options)

    command.execute(output: output)

    expect(output.string).to eq("OK\n")
  end
end
