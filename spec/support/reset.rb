RSpec.configure do |config|
  config.after do
    Thread.current[:figaro_config] = nil
  end
end
