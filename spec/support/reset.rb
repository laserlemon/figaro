# frozen_string_literal: true

RSpec.configure do |config|
  config.around do |example|
    original_env = ENV.to_hash
    example.run
  ensure
    ENV.replace(original_env)
    Thread.current[:figaro_config] = nil
  end
end
