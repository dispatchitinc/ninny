# frozen_string_literal: true

require 'ninny/commands/setup'
require 'tty-prompt'

# rubocop:disable Metrics/BlockLength

RSpec.describe Ninny::Commands::Setup do
  subject { Ninny::Commands::Setup.new({}) }
  it 'executes `setup` command successfully' do
    expect(subject).to receive(:try_reading_user_config)
    expect(subject).to receive(:prompt_for_gitlab_private_token)
    output = StringIO.new

    subject.execute(output: output)

    expect(output.string).to eq("User config \n")
  end

  context '#try_reading_user_config' do
    it 'should read config if present' do
      expect(Ninny.user_config).to receive(:read)
      subject.try_reading_user_config
      expect(subject.instance_variable_get('@result')).to eq('updated')
    end

    it 'should rescue missing config and set to created' do
      expect(Ninny.user_config).to receive(:read).and_raise(Ninny::MissingUserConfig)
      subject.try_reading_user_config
      expect(subject.instance_variable_get('@result')).to eq('created')
    end
  end

  context '#prompt_for_gitlab_private_token' do
    it 'should prompt for token if none exists' do
      expect(Ninny.user_config).to receive(:gitlab_private_token)
      expect_any_instance_of(TTY::Prompt).to receive(:yes?).with('Do you have a gitlab private token?')
      subject.prompt_for_gitlab_private_token
    end

    it 'should promt for new token if one exists' do
      expect(Ninny.user_config).to receive(:gitlab_private_token).and_return 'xxx'
      expect_any_instance_of(TTY::Prompt).to receive(:yes?).with('Do you have a new gitlab private token?')
      subject.prompt_for_gitlab_private_token
    end

    it 'should ask for and set the new token' do
      expect(Ninny.user_config).to receive(:gitlab_private_token)
      expect_any_instance_of(TTY::Prompt).to receive(:yes?).with('Do you have a gitlab private token?').and_return(true)
      expect_any_instance_of(TTY::Prompt).to receive(:ask).with('Enter private token', required: true).and_return('yyy')
      expect(Ninny.user_config).to receive(:set).with(:gitlab_private_token, value: 'yyy')
      subject.prompt_for_gitlab_private_token
    end
  end
end

# rubocop:enable Metrics/BlockLength
