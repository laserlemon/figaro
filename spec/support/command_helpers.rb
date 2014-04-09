module CommandHelpers
  def commands
    CommandInterceptor.commands
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
