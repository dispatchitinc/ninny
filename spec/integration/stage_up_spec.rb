# frozen_string_literal: true

RSpec.describe '`ninny stage_up` command', type: :cli do
  it 'executes `ninny help stage_up` command successfully' do
    output = `ninny help stage_up`
    expected_output = <<~OUT
            Usage:
              ninny stage_up [PULL_REQUEST_ID]
      #{'      '}
            Options:
              -h, [--help], [--no-help]  # Display usage information
      #{'      '}
            Merges PR/MR into the staging branch
    OUT

    expect(output).to eq(expected_output)
  end
end
