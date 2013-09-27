RSpec.configure do |config|
  config.before do
    Figaro.application = nil
  end
end
