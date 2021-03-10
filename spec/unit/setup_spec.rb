# frozen_string_literal: true

require 'ninny/commands/setup'
require 'tty-prompt'

# rubocop:disable Metrics/BlockLength
RSpec.describe Ninny::Commands::Setup do
  subject { Ninny::Commands::Setup.new({}) }

  it 'executes `setup` command successfully' do
    expect(subject).to receive(:try_reading_user_config)
    expect(subject).to receive(:prompt_for_gitlab_private_token).and_return(:token)
    expect(Ninny.user_config).to receive(:set).with(:gitlab_private_token, value: :token)
    expect(subject).to receive(:write_gitlab_private_token).with(:token, :success)
    output = StringIO.new
    subject.execute(output: output)
    expect(output.string).to eq("User config !\n")
  end

  it 'returns when the user does not give a token' do
    expect(subject).to receive(:try_reading_user_config)
    expect(subject).to receive(:prompt_for_gitlab_private_token).and_return(nil)
    output = StringIO.new
    subject.execute(output: output)
    expect(output.string).to eq("Please create a private token on GitLab and then rerun 'ninny setup'.\n")
  end

  it 'should not ask questions when the token is passed in' do
    subject = Ninny::Commands::Setup.new({ token: :token })
    expect(subject).to receive(:try_reading_user_config)
    expect(subject).not_to receive(:prompt_for_gitlab_private_token)
    expect(Ninny.user_config).to receive(:set)
    expect(subject).to receive(:write_gitlab_private_token)
    output = StringIO.new
    subject.execute(output: output)
    expect(output.string).to eq("User config !\n")
  end

  context 'when unable to write the config file via TTY' do
    it 'should move on and update it anyway' do
      allow(subject).to receive(:try_reading_user_config)
      allow(subject).to receive(:prompt_for_gitlab_private_token).and_return(:token)
      allow(Ninny.user_config).to receive(:write).with(force: true).and_raise(StandardError)
      expect(File).to receive(:open).and_return(true)
      subject.execute(output: StringIO.new)
    end
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
      expect_any_instance_of(TTY::Prompt).to receive(:yes?).with('Do you have a GitLab private token?')
      subject.prompt_for_gitlab_private_token
    end

    it 'should promt for new token if one exists' do
      expect(Ninny.user_config).to receive(:gitlab_private_token).and_return 'xxx'
      expect_any_instance_of(TTY::Prompt).to receive(:yes?).with('Do you have a new GitLab private token?')
      subject.prompt_for_gitlab_private_token
    end

    it 'should ask for the new token' do
      expect(Ninny.user_config).to receive(:gitlab_private_token)
      expect_any_instance_of(TTY::Prompt).to receive(:yes?).with('Do you have a GitLab private token?').and_return(true)
      expect_any_instance_of(TTY::Prompt).to receive(:ask).with(
        'Enter private token:',
        required: true
      ).and_return(:token)
      subject.prompt_for_gitlab_private_token
    end

    context 'when unable to set via TTY' do
      it 'should move on anyway' do
        allow(Ninny.user_config).to receive(:gitlab_private_token)
        allow_any_instance_of(TTY::Prompt).to receive(:yes?).with(
          'Do you have a GitLab private token?'
        ).and_return(true)
        allow_any_instance_of(TTY::Prompt).to receive(:ask).with(
          'Enter private token:',
          required: true
        ).and_return(:token)
        allow(Ninny.user_config).to receive(:set).with(:gitlab_private_token, value: :token).and_raise(ArgumentError)
        subject.prompt_for_gitlab_private_token
      end

      it 'should return the private token' do
        allow(Ninny.user_config).to receive(:gitlab_private_token)
        allow_any_instance_of(TTY::Prompt).to receive(:yes?).with(
          'Do you have a GitLab private token?'
        ).and_return(true)
        allow_any_instance_of(TTY::Prompt).to receive(:ask).with(
          'Enter private token:',
          required: true
        ).and_return(:token)
        allow(Ninny.user_config).to receive(:set).with(:gitlab_private_token, value: :token).and_raise(ArgumentError)
        expect(subject.prompt_for_gitlab_private_token).to eq(:token)
      end
    end
  end
end
# rubocop:enable Metrics/BlockLength
