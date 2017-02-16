require "bundler"
Bundler.setup

if ENV["CODECLIMATE_REPO_TOKEN"]
  require "codeclimate-test-reporter"
  CodeClimate::TestReporter.start
end

# This block of code helps to test the Railtie initialisation order. It cannot go directly in a spec
# as it is about how gems are required.
require 'rails'
require 'combustion'
Combustion.initialize!

require "figaro"

Bundler.require(:test)

Dir[File.expand_path("../support/*.rb", __FILE__)].each { |f| require f }
