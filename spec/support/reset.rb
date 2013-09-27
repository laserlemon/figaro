RSpec.configure do |config|
  config.before do
    Figaro.backend = nil
    Figaro.application = nil
  end
end
