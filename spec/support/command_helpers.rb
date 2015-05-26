module CommandHelpers
  def commands
    CommandInterceptor.commands
  end

  def expect_ran(*args)
    expected_name, *expected_args = args
    command = commands.last
    expect(command.name).to eq(expected_name)
    expect(command.args).to eq(expected_args) if expected_args.any?
  end
end

RSpec.configure do |config|
  config.include(CommandHelpers)

  config.before(:suite) do
    CommandInterceptor.setup
  end

  config.before do
    CommandInterceptor.reset
  end
end
