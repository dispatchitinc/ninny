RSpec.describe "`ninny staging_branch` command", type: :cli do
  it "executes `ninny help staging_branch` command successfully" do
    output = `ninny help staging_branch`
    expected_output = <<-OUT
Usage:
  ninny staging_branch

Options:
  -h, [--help], [--no-help]  # Display usage information

Returns the current staging branch
    OUT

    expect(output).to eq(expected_output)
  end
end
