require "bundler"
Bundler.setup

require "figaro"

Bundler.require(:test)

Dir[File.expand_path("../support/*.rb", __FILE__)].each { |f| require f }
