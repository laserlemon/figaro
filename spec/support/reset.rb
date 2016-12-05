RSpec.configure do |config|
  config.around do |example|
    original_env_keys = ENV.keys

    example.run

    new_env_keys = ENV.keys - original_env_keys
    new_env_keys.each { |key| ENV[key] = nil }

    Thread.current[:figaro_config] = nil
  end
end
