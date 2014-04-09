RSpec.configure do |config|
  config.before do
    Figaro.adapter = nil
    Figaro.application = nil
  end
end
