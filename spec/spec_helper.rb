require "bundler"
Bundler.setup

if ENV["COVERAGE"]
  require "codeclimate-test-reporter"
  CodeClimate::TestReporter.start
end

require "figaro"

Bundler.require(:test)

Dir[File.expand_path("../support/*.rb", __FILE__)].each { |f| require f }
