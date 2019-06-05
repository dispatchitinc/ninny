RSpec.describe "`ninny new_staging` command", type: :cli do
  it "executes `ninny help new_staging` command successfully" do
    output = `ninny help new_staging`
    expected_output = <<-OUT
Usage:
  ninny new_staging

Options:
  -h, [--help], [--no-help]  # Display usage information

Command description...
    OUT

    expect(output).to eq(expected_output)
  end
end
