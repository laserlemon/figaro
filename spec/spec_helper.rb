require "figaro"
require "pathname"
require "bundler"

ROOT = Pathname.new(File.expand_path("../..", __FILE__))

Dir[ROOT.join("spec/support/**/*.rb")].each { |f| require f }
