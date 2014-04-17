RSpec.configure do |config|
  config.before(:suite) do
    $original_env_keys = ::ENV.keys
  end

  config.before do
    Figaro.adapter = nil
    Figaro.application = nil

    # Restore the original state of ENV for each test
    ::ENV.keep_if { |k, _| $original_env_keys.include?(k) }
  end
end
