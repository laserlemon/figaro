if ENV["COVERAGE"]
  require "simplecov"
  SimpleCov.start { add_filter("features") }
end

require "pathname"

ROOT = Pathname.new(File.expand_path("../../..", __FILE__))
