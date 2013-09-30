if ENV["COVERAGE"]
  require "coveralls"
  Coveralls.wear!
end

require "figaro"

require "bundler"
Bundler.require(:test)

require "pathname"
ROOT = Pathname.new(File.expand_path("../..", __FILE__))

Dir[ROOT.join("spec/support/**/*.rb")].each { |f| require f }
